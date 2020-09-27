import ArgumentParser
import BlinkKit
import Combine
import Foundation

struct GetCameraThumbnail: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Download Camera Thumbnail"
    )
    
    @Option(help: "Network ID")
    private var networkID: Int
    
    @Option(help: "Camera ID")
    private var cameraID: Int
    
    func run() throws {
        var cancellables = Set<AnyCancellable>()
        
        await { exit in
            BlinkController(globalOptions: globalOptions)
                .getCameraThumbnail(networkID: networkID, cameraID: cameraID)
                .awaitAndTrack(exit: exit, cancellables: &cancellables)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
