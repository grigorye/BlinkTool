import ArgumentParser
import BlinkKit

struct ToggleCamera: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Toggle camera"
    )
    
    @Option(help: "Network ID")
    private var networkID: Int
    
    @Option(help: "Camera ID")
    private var cameraID: Int
    
    @Flag(help: "On/Off")
    private var on: OnOff
    
    func run() async throws {
        try await track {
            try await blinkController().toggleCamera(networkID: networkID, cameraID: cameraID, on: on == .on)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}

private enum OnOff: EnumerableFlag {
    case on
    case off
}
