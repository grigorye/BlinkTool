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
    traceAsNecessary(
        error, file: file, line: line, column: column, function: function,
        moduleReference: .dso(dsohandle))
    return error
}

func track<T: Codable>(
    _ value: T, file: StaticString = #file, line: Int = #line, column: UInt = #column,
    dsohandle: UnsafeRawPointer = #dsohandle
) {
    switch jsonOutput {
    case .none:
        dump(value)
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
