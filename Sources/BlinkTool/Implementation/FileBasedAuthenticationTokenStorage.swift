import BlinkKit
import Foundation
import GETracing

#if !os(Linux)
    import Combine
#else
    import OpenCombine
#endif

struct FileBasedAuthenticationTokenStorage: AuthenticationTokenStorage {
    
    let tokenStorageURL: URL
    
    func save(_ authenticatedAccount: AuthenticatedAccount) throws {
        try saveAuthenticatedAccount(newValue: authenticatedAccount, tokenStorageURL: tokenStorageURL)
    }
    
    var load: AnyPublisher<AuthenticatedAccount?, Error> {
        loadAuthenticatedAccount(tokenStorageURL: tokenStorageURL)
    }
}

func fileBasedTokenStorageURL(storageDirectory: URL, email: String) -> URL {
    storageDirectory.appendingPathComponent(email)
}

func loadAuthenticatedAccount(tokenStorageURL: URL) -> AnyPublisher<AuthenticatedAccount?, Error> {
    Future { promise in
        promise(
            Result {
                let data = try Data(contentsOf: tokenStorageURL)
                return try JSONDecoder().decode(AuthenticatedAccount.self, from: data)
            }.mapError { error in
                track(error)
            }
        )
    }.eraseToAnyPublisher()
}

func saveAuthenticatedAccount(newValue: AuthenticatedAccount?, tokenStorageURL: URL) throws {
    if let token = newValue {
        let data = try JSONEncoder().encode(token)
        let writeData = {
            try data.write(to: tokenStorageURL)
        }
        let writeDataAfterCreatingDirectory = {
            let fileManager = FileManager.default
            let tokenStorageParentDirectory = tokenStorageURL.deletingLastPathComponent()
            try fileManager.createDirectory(
                at: tokenStorageParentDirectory, withIntermediateDirectories: true, attributes: nil)
            try writeData()
        }
        do {
            try writeData()
        } catch CocoaError.fileNoSuchFile {
            try writeDataAfterCreatingDirectory()
        } catch {
            #if os(Linux)
                let error = (error as NSError)
                guard !(error.domain == NSCocoaErrorDomain && error.code == NSFileNoSuchFileError) else {
                    try writeDataAfterCreatingDirectory()
                    return
                }
            #endif
            throw x$(error)
        }
    } else {
        try FileManager.default.removeItem(at: tokenStorageURL)
    }
}
