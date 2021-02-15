import BlinkKit

extension BlinkController {
    
    init(globalOptions: GlobalOptions) {
        let email = globalOptions.email
        let password = globalOptions.password
        let reauth = globalOptions.reauth
        self.init(email: email, password: password, reauth: reauth)
    }
    
    init(email: String, password: String?, reauth: Bool) {
        let authenticationTokenStorage = defaultAuthenticationTokenStorage(email: email)
        self.init(email: email, password: password, reauth: reauth, authenticationTokenStorage: authenticationTokenStorage)
    }
}
