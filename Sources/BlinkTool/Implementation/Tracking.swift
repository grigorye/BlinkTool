import Foundation
import GETracing

func track(
    _ error: Error, file: StaticString = #file, line: Int = #line, column: UInt = #column,
    dsohandle: UnsafeRawPointer = #dsohandle
) {
    traceAsNecessary(
        error, file: file, line: line, column: column, function: "track",
        moduleReference: .dso(dsohandle))
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
