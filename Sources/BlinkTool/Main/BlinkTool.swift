import GETracing
import ArgumentParser
import BlinkKit

protocol BlinkCommand: AsyncParsableCommand {
    var globalOptions: GlobalOptions { get }
}

extension BlinkCommand {
    func validate() throws {
        jsonOutput = globalOptions.jsonOutput
    }
    
    func blinkController() async throws -> BlinkController {
        let accountID = try await BlinkAuthenticator(globalOptions: globalOptions).loggedIn()
        return BlinkController(accountID: accountID)
    }
}

@main
struct BlinkTool: AsyncParsableCommand {
    
    static let configuration = {
        traceEnabledEnforced = true
        sourceLabelsEnabledEnforced = true
        dumpInTraceEnabledEnforced = true
        
        return CommandConfiguration(
            abstract: "Tool to manage Blink cameras",
            subcommands: [
                Login.self,
                VerifyPin.self,
                HomeScreen.self,
                GetCameraThumbnail.self,
                GetVideoEvents.self,
                GetVideoEventsMedia.self,
                GetVideo.self,
                ToggleCamera.self,
            ]
        )
    }()
}

var jsonOutput: JsonOutput?
