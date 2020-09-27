import BlinkKit
import Combine
import Foundation

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
        do {
            try writeData()
        } catch CocoaError.fileNoSuchFile {
            let fileManager = FileManager.default
            let tokenStorageParentDirectory = tokenStorageURL.deletingLastPathComponent()
            try fileManager.createDirectory(
                at: tokenStorageParentDirectory, withIntermediateDirectories: true, attributes: nil)
            try writeData()
        }
    } else {
        try FileManager.default.removeItem(at: tokenStorageURL)
    }
}
