import ArgumentParser
import BlinkKit

#if !os(Linux)
    import Combine
#else
    import OpenCombine
#endif

struct HomeScreen: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Show home screen info"
    )
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            BlinkController(globalOptions: globalOptions)
                .homeScreen()
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
