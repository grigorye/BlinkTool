import ArgumentParser
import BlinkKit
import BlinkOpenAPI
import Combine
import Foundation

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
            let blinkController = BlinkController(globalOptions: globalOptions)
            return
                blinkController
                .videoEvents(page: page, since: sinceDate)
                .flatMap { videoEvents in
                    Publishers.Sequence(sequence: videoEvents.media).eraseToAnyPublisher()
                }
                .flatMap { media in
                    blinkController.getVideo(media: media.media).eraseToAnyPublisher()
                }
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
