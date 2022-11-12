import ArgumentParser
import BlinkKit
import Foundation
import GETracing

struct GetVideoEvents: BlinkCommand {
    
    public static let configuration = CommandConfiguration(
        abstract: "Get video events"
    )
    
    @Option(help: "Page")
    private var page: Int?
    
    @Option(name: .customLong("since"), help: "Since date")
    private var sinceDateString: String?
    
    func run() async throws {
        try await track {
            let videoEventsForPage = { try await blinkController().videoEvents(page: $0, since: sinceDate) }
            return try await Self.queryMedia(page: page, videoEventsForPage: videoEventsForPage)
        }
    }
    
    private var sinceDate: Date {
        guard let sinceDateString = sinceDateString else {
            return .distantPast
        }
        return ISO8601DateFormatter().date(from: sinceDateString)
            ?? {
                assertionFailure()
                return .distantPast
            }()
    }
    
    @OptionGroup var globalOptions: GlobalOptions
}

extension GetVideoEvents {
    
    static func queryMedia(
        page: Int?,
        videoEventsForPage: @escaping (Int) async throws -> VideoEvents
    ) async throws -> [Media] {
        if let page = page {
            return try await Self.queryMedia(page: page, videoEventsForPage: videoEventsForPage)
        } else {
            return try await Self.queryMediaForAllPages(videoEventsForPage: videoEventsForPage)
        }
    }
    
    static func queryMedia(
        page: Int,
        videoEventsForPage: @escaping (Int) async throws -> VideoEvents
    ) async throws -> [Media] {
        try await videoEventsForPage(page).media
    }
    
    static func queryMediaForAllPages(
        videoEventsForPage: @escaping (Int) async throws -> VideoEvents
    ) async throws -> [Media] {
        let media = try await queryMediaForAllPagesIgnoringDuplicates(videoEventsForPage: videoEventsForPage)
        let uniqMedia = deduplicateMedia(media)
        return uniqMedia
    }
    
    static func deduplicateMedia(_ media: [Media]) -> [Media] {
        // Deduplicate, accounting the shift of pages forward due to new entries recorded between the calls.
        let uniqMedia = media.deduplicated()
        let duplicatesCount = uniqMedia.count - media.count
        if duplicatesCount > 0 {
            x$(duplicatesCount)
        }
        return uniqMedia
    }
    
    static func queryMediaForAllPagesIgnoringDuplicates(
        videoEventsForPage: @escaping (Int) async throws -> VideoEvents
    ) async throws -> [Media] {
        var media: [Media] = []
        for page in 1...Int.max {
            let pageMedia = try await videoEventsForPage(page).media
            if pageMedia.isEmpty {
                return media
            }
            media += pageMedia
        }
        return media
    }
}

extension Array {
    fileprivate func deduplicated() -> Self {
        NSOrderedSet(array: self).array as! [Element]
    }
}
