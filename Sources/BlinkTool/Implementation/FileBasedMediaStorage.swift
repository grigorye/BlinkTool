import Foundation

func defaultMediaStorageRootURL() -> URL {
    let fileManager = FileManager.default
    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent("Blink")
}

func defaultMediaStorage(rootURL: URL = defaultMediaStorageRootURL()) -> MediaStorage & ExistingMediaStorage {
    FileBasedMediaStorage(rootURL: rootURL)
}
