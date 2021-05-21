import ArgumentParser
import BlinkKit

#if !os(Linux)
import Combine
#else
import OpenCombine
#endif

struct ToggleCamera: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Toggle camera"
    )
    
    @Option(help: "Network ID")
    private var networkID: Int
    
    @Option(help: "Camera ID")
    private var cameraID: Int
    
    @Flag(help: "On/Off")
    private var on: OnOff
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        `await` { exit in
            BlinkController(globalOptions: globalOptions)
                .toggleCamera(networkID: networkID, cameraID: cameraID, on: on == .on)
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}

private enum OnOff: EnumerableFlag {
    case on
    case off
}
