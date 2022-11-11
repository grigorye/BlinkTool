import ArgumentParser
import BlinkKit

struct VerifyPin: AsyncParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Verify PIN"
    )
    
    @Option(help: "Pin")
    private var pin: String
    
    @Option(help: "Password")
    private var password: String
    
    func run() async throws {
        try await track {
            try await BlinkAuthenticator(email: globalOptions.email, password: password, reauth: globalOptions.reauth)
                .verifyPin(pin: pin)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
