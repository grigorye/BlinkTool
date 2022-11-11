import ArgumentParser
import BlinkKit

struct GetVideo: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get video"
    )
    
    @Option(help: "Media Path")
    private var media: String
    
    func run() async throws {
        try await track {
            try await blinkController().getVideo(media: media)
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
