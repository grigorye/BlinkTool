import ArgumentParser
import BlinkKit
import Foundation

#if !os(Linux)
import Combine
#else
import OpenCombine
#endif

struct GetVideoEvents: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get video events"
    )
    
    @Option(help: "Page")
    private var page: Int?
    
    @Option(name: .customLong("since"), help: "Since date")
    private var sinceDateString: String?
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        `await` { exit in
            let blinkController = BlinkController(globalOptions: globalOptions)
            let videoEventsForPage = { blinkController.videoEvents(page: $0, since: sinceDate) }
            let queryMedia = Self.queryMedia(page: page, videoEventsForPage: videoEventsForPage)
            queryMedia
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

extension GetVideoEvents {
    
    static func queryMedia(
        page: Int?,
        videoEventsForPage: @escaping (Int) -> AnyPublisher<VideoEvents, Error>
    ) -> AnyPublisher<[Media], Error> {
        if let page = page {
            return GetVideoEvents.queryMedia(page: page, videoEventsForPage: videoEventsForPage)
        } else {
            return GetVideoEvents.queryMediaForAllPages(videoEventsForPage: videoEventsForPage)
        }
    }
    
    static func queryMedia(
        page: Int,
        videoEventsForPage: @escaping (Int) -> AnyPublisher<VideoEvents, Error>
    ) -> AnyPublisher<[Media], Error> {
        videoEventsForPage(page)
            .map(\.media)
            .eraseToAnyPublisher()
    }
    
    static func queryMediaForAllPages(
        videoEventsForPage: @escaping (Int) -> AnyPublisher<VideoEvents, Error>
    ) -> AnyPublisher<[Media], Error> {
        (1...Int.max)
            .publisher
            .setFailureType(to: Error.self)
            .flatMap(maxPublishers: .max(1), videoEventsForPage)
            .map(\.media)
            .prefix { $0.isEmpty != true }
            .eraseToAnyPublisher()
    }
}
