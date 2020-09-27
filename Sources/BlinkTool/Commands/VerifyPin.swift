import ArgumentParser
import BlinkKit
import Combine

struct VerifyPin: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Verify PIN"
    )
    
    @Option(help: "Pin")
    private var pin: String
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            BlinkController(globalOptions: globalOptions)
                .verifyPin(pin: pin)
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
