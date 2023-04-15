import ArgumentParser
import BlinkKit

struct Version: ParsableCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Print the current version of the tool"
    )
    
    func run() throws {
        print(bundleVersion)
    }
}
