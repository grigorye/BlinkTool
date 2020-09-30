import ArgumentParser
import BlinkKit

protocol BlinkCommand: ParsableCommand {
    var globalOptions: GlobalOptions { get }
}

extension BlinkCommand {
    func validate() throws {
        jsonOutput = globalOptions.jsonOutput
    }
}

struct BlinkTool: ParsableCommand {
    
    static let configuration = CommandConfiguration(
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
}

var jsonOutput: JsonOutput?
