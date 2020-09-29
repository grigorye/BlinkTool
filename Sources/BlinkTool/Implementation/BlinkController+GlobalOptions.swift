import BlinkKit

extension BlinkController {
    
    init(globalOptions: GlobalOptions) {
        let email = globalOptions.email
        let password = globalOptions.password
        self.init(email: email, password: password)
    }
    
    init(email: String, password: String?) {
        let authenticationTokenStorage = defaultAuthenticationTokenStorage(email: email)
        self.init(email: email, password: password, authenticationTokenStorage: authenticationTokenStorage)
    }
}
