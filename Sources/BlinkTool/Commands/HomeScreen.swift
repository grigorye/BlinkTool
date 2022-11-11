import ArgumentParser
import BlinkKit

struct HomeScreen: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Show home screen info"
    )
    
    func run() async throws {
        try await track {
            try await blinkController().homeScreen()
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
