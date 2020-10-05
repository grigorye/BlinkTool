import ArgumentParser
import BlinkKit
import Foundation

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
    
    @Option(name: .customLong("since"), help: "Since date")
    private var sinceDateString: String?
    
    @Option(name: .customLong("destination"), help: "Root")
    private var destinationPath: String?
    
    private var rootURL: URL {
        destinationPath.flatMap { URL(fileURLWithPath: $0) } ?? defaultMediaStorageRootURL()
    }
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            let mediaStorage: MediaStorage = defaultMediaStorage(rootURL: rootURL)
            let blinkController = BlinkController(globalOptions: globalOptions)
            let videoEventsForPage = { blinkController.videoEvents(page: $0, since: sinceDate) }
            let queryMedia: AnyPublisher<[Media], Error> = {
                if let page = page {
                    return GetVideoEvents.queryMedia(page: page, videoEventsForPage: videoEventsForPage)
                } else {
                    return GetVideoEvents.queryMediaForAllPages(videoEventsForPage: videoEventsForPage)
                }
            }()
            let getVideo = { blinkController.getVideo(media: $0) }
            let urlForStoredMedia = { mediaStorage.urlForMedia($0) }
            return Self.downloadMedia(queryMedia: queryMedia, getVideo: getVideo, urlForStoredMedia: urlForStoredMedia)
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
        queryMedia: AnyPublisher<[Media], Error>,
        getVideo: @escaping (String) -> AnyPublisher<VideoResponse, Error>,
        urlForStoredMedia: @escaping (Media) -> URL,
        fileManager: FileManager = FileManager.default
    ) -> AnyPublisher<URL, Error> {
        queryMedia
            .flatMap { (media: [Media]) in
                Publishers.Sequence(sequence: media)
            }
            .flatMap { (media: Media) -> AnyPublisher<URL, Error> in
                let mediaURL = urlForStoredMedia(media)
                assert(mediaURL.isFileURL)
                guard fileManager.fileExists(atPath: mediaURL.path) == false else {
                    return Result<URL, Error>.Publisher(mediaURL).eraseToAnyPublisher()
                }
                return getVideo(media.media)
                    .tryMap { response in
                        let mediaDirectoryURL = mediaURL.deletingLastPathComponent()
                        try fileManager.createDirectory(at: mediaDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                        try fileManager.moveItem(at: response.url, to: mediaURL)
                        return mediaURL
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
