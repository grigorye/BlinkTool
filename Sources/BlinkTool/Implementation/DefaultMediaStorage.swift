import BlinkOpenAPI
import Foundation

struct FileBasedMediaStorage: MediaStorage {
    
    func urlForMedia(_ media: Media) -> URL {
        let path = storageRelativePath(for: media)
        return rootURL.appendingPathComponent(path, isDirectory: false)
    }
    
    var rootURL: URL
}

func storageRelativePath(for media: Media, formatDate: (Date) -> String = formatDate) -> String {
    let components: [String] = [
        formatDate(media.createdAt),
        media.type.rawValue,
        "\(media.id)",
    ]
    let pathExtension = URL(fileURLWithPath: media.media).pathExtension
    let path = (media.deviceName + "/" + components.joined(separator: "-")) + "." + pathExtension
    return path
}

private let mediaFileDateFormatter = ISO8601DateFormatter()
private let formatDate: (Date) -> String = mediaFileDateFormatter.string(from:)
