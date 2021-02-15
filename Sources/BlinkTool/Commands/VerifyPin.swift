import ArgumentParser
import BlinkKit

#if !os(Linux)
import Combine
#else
import OpenCombine
#endif

struct VerifyPin: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Verify PIN"
    )
    
    @Option(help: "Pin")
    private var pin: String
    
    @Option(help: "Password")
    private var password: String
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        await { exit in
            BlinkController(email: globalOptions.email, password: password, reauth: globalOptions.reauth)
                .verifyPin(pin: pin)
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
