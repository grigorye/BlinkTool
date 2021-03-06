import ArgumentParser

struct GlobalOptions: ParsableArguments {
    @Option(help: "E-mail")
    var email: String
    
    @Option(help: "Password")
    var password: String?
    
    @Option(help: "Reauthenticate")
    var reauth: Bool = true
    
    @Option(name: .customLong("json"), help: "Enable JSON Output")
    var jsonOutput: JsonOutput?
}

enum JsonOutput: String, ExpressibleByArgument {
    case raw
    case pretty
}
