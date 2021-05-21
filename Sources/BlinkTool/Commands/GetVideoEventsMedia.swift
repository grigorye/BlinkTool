import ArgumentParser
import BlinkKit
import Foundation
import GETracing

#if !os(Linux)
import Combine
#else
import OpenCombine
#endif

protocol MediaStorage {
    func urlForMedia(_ media: Media) -> URL
}

struct GetVideoEventsMedia: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get media for video events"
    )
    
    @Option(help: "Page")
    private var page: Int?
    
    @Option(help: "Maximum number of simultaneous downloads")
    private var maxDownloads: Int?
    
    @Option(name: .customLong("since"), help: "Since date")
    private var sinceDateString: String?
    
    @Option(name: .customLong("destination"), help: "Root")
    private var destinationPath: String?
    
    private var rootURL: URL {
        destinationPath.flatMap { URL(fileURLWithPath: $0) } ?? defaultMediaStorageRootURL()
    }
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        `await` { exit in
            let mediaStorage: MediaStorage = defaultMediaStorage(rootURL: rootURL)
            let blinkController = BlinkController(globalOptions: globalOptions)
            let videoEventsForPage = { blinkController.videoEvents(page: $0, since: sinceDate) }
            let queryMedia = GetVideoEvents.queryMedia(page: page, videoEventsForPage: videoEventsForPage)
                .map { (media: [Media]) -> [Media] in
                    let uniqMedia = NSOrderedSet(array: media).array as! [Media]
                    let duplicatesCount = uniqMedia.count - media.count
                    if duplicatesCount > 0 {
                        x$(duplicatesCount)
                    }
                    return uniqMedia
                }
                .eraseToAnyPublisher()
            let getVideo = { blinkController.getVideo(media: $0) }
            let urlForStoredMedia = { mediaStorage.urlForMedia($0) }
            let downloadMedia = { Self.downloadMedia(getVideo: getVideo, media: $0, mediaURL: $1) }
            let queryMediaForDownload = {
                Self
                    .queryMediaForDownload(queryMedia: queryMedia, urlForStoredMedia: urlForStoredMedia)
            }
            return queryMediaForDownload()
                .flatMap(
                    maxPublishers: maxDownloads.flatMap { .max($0) } ?? .unlimited,
                    downloadMedia
                )
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    private var sinceDate: Date {
        guard let sinceDateString = sinceDateString else {
            return .distantPast
        }
        return ISO8601DateFormatter().date(from: sinceDateString)
            ?? {
                assertionFailure()
                return .distantPast
            }()
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}

extension GetVideoEventsMedia {
    
    static func downloadMedia(
        getVideo: @escaping (String) -> AnyPublisher<VideoResponse, Error>,
        media: String,
        mediaURL: URL,
        fileManager: FileManager = .default
    ) -> AnyPublisher<URL, Error> {
        getVideo(media)
            .tryMap { response -> URL in
                let mediaDirectoryURL = mediaURL.deletingLastPathComponent()
                try fileManager.createDirectory(at: mediaDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                try fileManager.moveItem(at: response.url, to: mediaURL)
                return mediaURL
            }
            .eraseToAnyPublisher()
    }
    
    static func queryMediaForDownload(
        queryMedia: AnyPublisher<[Media], Error>,
        urlForStoredMedia: @escaping (Media) -> URL,
        fileManager: FileManager = FileManager.default
    ) -> AnyPublisher<(media: String, mediaURL: URL), Error> {
        queryMedia
            .flatMap { (media: [Media]) in
                Publishers.Sequence<[Media], Error>(sequence: media)
            }
            .compactMap { (media: Media) in
                let mediaURL = urlForStoredMedia(media)
                assert(mediaURL.isFileURL)
                guard fileManager.fileExists(atPath: mediaURL.path) == false else {
                    return nil
                }
                return (media: media.media, mediaURL: mediaURL)
            }
            .eraseToAnyPublisher()
    }
}
