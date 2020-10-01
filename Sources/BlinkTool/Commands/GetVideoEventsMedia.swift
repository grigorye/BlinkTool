import ArgumentParser
import BlinkKit
import BlinkOpenAPI
import Combine
import Foundation

protocol MediaStorage {
    func urlForMedia(_ media: Media) -> URL
}

struct GetVideoEventsMedia: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get media for video events"
    )
    
    @Option(help: "Page")
    private var page: Int
    
    @Option(name: .customLong("since"), help: "Since date")
    private var sinceDateString: String?
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            let mediaStorage: MediaStorage = defaultMediaStorage()
            let blinkController = BlinkController(globalOptions: globalOptions)
            return
                downloadMedia(
                    videoEvents: blinkController.videoEvents(page: page, since: sinceDate),
                    getVideo: { blinkController.getVideo(media: $0) },
                    urlForMedia: { mediaStorage.urlForMedia($0) }
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

func downloadMedia(
    videoEvents: AnyPublisher<VideoEvents, Error>,
    getVideo: @escaping (String) -> AnyPublisher<VideoResponse, Error>,
    urlForMedia: @escaping (Media) -> URL,
    fileManager: FileManager = FileManager.default
) -> AnyPublisher<URL, Error> {
    videoEvents
        .flatMap { (videoEvents: VideoEvents) -> AnyPublisher<Media, Error> in
            Publishers.Sequence(sequence: videoEvents.media).eraseToAnyPublisher()
        }
        .flatMap { (media: Media) -> AnyPublisher<URL, Error> in
            let mediaURL = urlForMedia(media)
            assert(mediaURL.isFileURL)
            guard fileManager.fileExists(atPath: mediaURL.path) == false else {
                return Result.Publisher(mediaURL).eraseToAnyPublisher()
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
