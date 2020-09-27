import ArgumentParser
import BlinkKit
import Combine

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
