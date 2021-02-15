import BlinkOpenAPI
import Foundation
import GETracing

@discardableResult
func track<T: Error>(
    _ error: T,
    file: StaticString = #file,
    line: Int = #line,
    column: UInt = #column,
    function: StaticString = #function,
    dsohandle: UnsafeRawPointer = #dsohandle
) -> T {
    switch error {
    case .error(let code, let data, let response, let error) as ErrorResponse:
        guard let data = data else {
            fallthrough
        }
        guard let apiError = try? JSONDecoder().decode(ModelError.self, from: data) else {
            fallthrough
        }
        let info = (description: error.localizedDescription, code: code, error: apiError, response: response, underlyingError: error)
        traceAsNecessary(
            info, file: file, line: line, column: column, function: function,
            moduleReference: .dso(dsohandle))
    default:
        traceAsNecessary(
            error, file: file, line: line, column: column, function: function,
            moduleReference: .dso(dsohandle))
    }
    return error
}

func track<T: Codable>(
    _ value: T, file: StaticString = #file, line: Int = #line, column: UInt = #column,
    dsohandle: UnsafeRawPointer = #dsohandle
) {
    switch jsonOutput {
    case .none:
        dump(trackable(value))
    case .pretty, .raw:
        let jsonEncoder = JSONEncoder()
        if jsonOutput == .pretty {
            jsonEncoder.outputFormatting = .prettyPrinted
        }
        let data = try! jsonEncoder.encode(value)
        let string = String(data: data, encoding: .utf8)!
        print(string)
    }
}

func trackable<T: Codable>(_ v: T) -> Codable {
    switch v {
    case let url as URL:
        return url.path
    default:
        return v
    }
}
