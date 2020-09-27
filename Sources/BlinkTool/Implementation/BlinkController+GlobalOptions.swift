import BlinkKit

extension BlinkController {
    
    init(globalOptions: GlobalOptions) {
        let email = globalOptions.email
        let password = globalOptions.password
        let authenticationTokenStorage = defaultAuthenticationTokenStorage(email: email)
        self.init(
            email: email, password: password, authenticationTokenStorage: authenticationTokenStorage)
    }
}
