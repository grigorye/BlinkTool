import ArgumentParser
import BlinkKit

#if !os(Linux)
import Combine
#else
import OpenCombine
#endif

struct Login: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Login into account"
    )
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            BlinkController(globalOptions: globalOptions)
                .login()
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
