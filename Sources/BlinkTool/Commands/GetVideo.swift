import ArgumentParser
import BlinkKit
import Combine

struct GetVideo: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get video"
    )
    
    @Option(help: "Media ID")
    private var mediaID: Int
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            BlinkController(globalOptions: globalOptions)
                .getVideo(mediaID: mediaID)
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup private var globalOptions: GlobalOptions
}
