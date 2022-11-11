import ArgumentParser
import BlinkKit

struct Login: AsyncParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Login into account"
    )
    
    func run() async throws {
        try await track {
            try await BlinkAuthenticator(globalOptions: globalOptions)
                .login()
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
