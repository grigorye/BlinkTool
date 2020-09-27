import BlinkKit
import Foundation

func defaultAuthenticationTokenStorage(email: String) -> AuthenticationTokenStorage {
    let baseURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".BlinkTool")
    let tokenStorageURL = fileBasedTokenStorageURL(storageDirectory: baseURL, email: email)
    let authenticationTokenStorage = FileBasedAuthenticationTokenStorage(
        tokenStorageURL: tokenStorageURL)
    return authenticationTokenStorage
}
