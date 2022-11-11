import ArgumentParser
import BlinkKit
import Foundation
import GETracing

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
    
    func run() async throws {
        do {
            let mediaStorage: MediaStorage = defaultMediaStorage(rootURL: rootURL)
            let blinkController = try await blinkController()
            let videoEventsForPage = { try await blinkController.videoEvents(page: $0, since: sinceDate) }
            let queryMedia: () async throws -> [Media] = {
                let media = try await GetVideoEvents.queryMedia(page: page, videoEventsForPage: videoEventsForPage)
                let uniqMedia = NSOrderedSet(array: media).array as! [Media]
                let duplicatesCount = uniqMedia.count - media.count
                if duplicatesCount > 0 {
                    x$(duplicatesCount)
                }
                return uniqMedia
            }
            
            let getVideo = { try await blinkController.getVideo(media: $0) }
            let urlForStoredMedia = { mediaStorage.urlForMedia($0) }
            let mediaForDownload = try await Self.queryMediaForDownload(queryMedia: queryMedia, urlForStoredMedia: urlForStoredMedia)
            
            let semaphore = Semaphore(count: maxDownloads ?? .max)
            
            try await withThrowingTaskGroup(of: URL.self) { group in
                for media in mediaForDownload {
                    group.addTask {
                        try await semaphore.do {
                            try await Self.downloadMedia(getVideo: getVideo, media: media.media, mediaURL: x$(media.mediaURL))
                        }
                    }
                }
                try await track {
                    group
                }
            }
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
        getVideo: @escaping (String) async throws -> VideoResponse,
        media: String,
        mediaURL: URL,
        fileManager: FileManager = .default
    ) async throws -> URL {
        let response = try await getVideo(media)
        let mediaDirectoryURL = mediaURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: mediaDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        try fileManager.moveItem(at: response.url, to: mediaURL)
        return mediaURL
    }
    
    static func queryMediaForDownload(
        queryMedia: () async throws -> [Media],
        urlForStoredMedia: @escaping (Media) -> URL,
        fileManager: FileManager = FileManager.default
    ) async throws -> [(media: String, mediaURL: URL)] {
        let media = try await queryMedia()
        return media.compactMap { media in
            let mediaURL = urlForStoredMedia(media)
            assert(mediaURL.isFileURL)
            guard fileManager.fileExists(atPath: mediaURL.path) == false else {
                return nil
            }
            return (media: media.media, mediaURL: mediaURL)
        }
    }
}
