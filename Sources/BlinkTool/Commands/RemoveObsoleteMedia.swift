import ArgumentParser
import AsyncAlgorithms
import BlinkKit
import Foundation

protocol ExistingMediaStorage {
    func existingMedia() async throws -> [URL]
}

struct RemoveObsoleteMedia: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Remove media that is no longer available remotely."
    )
    
    @Option(name: .customLong("destination"), help: "Root")
    private var destinationPath: String?
    
    private var rootURL: URL {
        destinationPath.flatMap { URL(fileURLWithPath: $0) } ?? defaultMediaStorageRootURL()
    }
    
    func run() async throws {
        let mediaStorage = defaultMediaStorage(rootURL: rootURL)
        let blinkController = try await blinkController()
        let videoEventsForPage = { try await blinkController.videoEvents(page: $0, since: .distantPast) }
        let queryMedia: () async throws -> [Media] = {
            try await GetVideoEvents.queryMediaForAllPages(videoEventsForPage: videoEventsForPage)
        }
        
        let urlForStoredMedia = { mediaStorage.urlForMedia($0) }
        async let existingMedia = try await mediaStorage.existingMedia()
        let remoteMedia = try await queryMedia().map { urlForStoredMedia($0).resolvingSymlinksInPath() }
        let mediaToRemove = try await existingMedia.filter { !remoteMedia.contains($0) }
        
        await track {
            mediaToRemove.async.map { mediaURL in
                try! FileManager.default.removeItem(at: mediaURL)
                return mediaURL
            }
        }
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}
