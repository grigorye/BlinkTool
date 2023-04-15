import PackagePlugin
import Foundation

@main
struct GenerateBundleVersion: BuildToolPlugin {
    
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        let bundleVersionFile = context.pluginWorkDirectory.appending("BundleVersion.swift")
        
        let arguments = prebuildCommandArguments(context: context, arguments: [
            "SPMBuildScripts/GenerateBundleVersionDotSwift"
        ])
        let environment = prebuildCommandEnvironment(context: context, environment: [
            "__BUNDLE_VERSION_FILE": bundleVersionFile
        ])
        
        return ([
            .prebuildCommand(
                displayName: "Generate Bundle Version",
                executable: .init("/bin/bash"),
                arguments: arguments,
                environment: environment,
                outputFilesDirectory: context.pluginWorkDirectory
            ),
        ])
    }
}

func prebuildCommandEnvironment(context: PackagePlugin.PluginContext, environment: [String: CustomStringConvertible]) -> [String: CustomStringConvertible] {
    // .prebuildCommand does not have any environment, propagate the current environment as a workaround.
    environment.merging(ProcessInfo.processInfo.environment, uniquingKeysWith: { $1 })
}

func prebuildCommandArguments(context: PackagePlugin.PluginContext, arguments: [CustomStringConvertible]) -> [CustomStringConvertible] {
    // .prebuildCommand runs from '/', cd to our root as a workaround.
    let runFromWorkingTreeRoot = context.package.directory.appending(["SPMBuildScripts", "RunFromWorkingTreeRoot"]).string
    let arguments = [runFromWorkingTreeRoot] + arguments
    return arguments
}
