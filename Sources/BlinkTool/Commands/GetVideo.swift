import ArgumentParser
import BlinkKit

#if !os(Linux)
    import Combine
#else
    import OpenCombine
#endif

struct GetVideo: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get video"
    )
    
    @Option(help: "Media Path")
    private var media: String
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            BlinkController(globalOptions: globalOptions)
                .getVideo(media: media)
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup private var globalOptions: GlobalOptions
}
