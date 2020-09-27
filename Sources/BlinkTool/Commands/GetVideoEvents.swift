import ArgumentParser
import BlinkKit
import Combine
import Foundation

struct GetVideoEvents: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get video events"
    )
    
    @Option(help: "Page")
    private var page: Int
    
    @Option(name: .customLong("since"), help: "Since date")
    private var sinceDateString: String?
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            BlinkController(globalOptions: globalOptions)
                .videoEvents(page: page, since: sinceDate)
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
