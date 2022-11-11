import ArgumentParser
import BlinkKit

struct GetCameraThumbnail: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Download Camera Thumbnail"
    )
    
    @Option(help: "Network ID")
    private var networkID: Int
    
    @Option(help: "Camera ID")
    private var cameraID: Int
    
    func run() async throws {
        try await track {
            try await blinkController().getCameraThumbnail(networkID: networkID, cameraID: cameraID)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
