import BlinkKit

extension BlinkAuthenticator {
    
    init(globalOptions: GlobalOptions) {
        let email = globalOptions.email
        let password = globalOptions.password
        let reauth = globalOptions.reauth
        self.init(email: email, password: password, reauth: reauth)
    }
}

extension BlinkAuthenticator {
    init(email: String, password: String?, reauth: Bool) {
        let authenticationTokenStorage = defaultAuthenticationTokenStorage(email: email)
        self.init(email: email, password: password, reauth: reauth, authenticationTokenStorage: authenticationTokenStorage)
    }
}
