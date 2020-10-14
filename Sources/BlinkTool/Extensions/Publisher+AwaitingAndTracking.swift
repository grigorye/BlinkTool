#if !os(Linux)
import Combine
#else
import OpenCombine
#endif

enum ExitStatus {
    case success, failure
}

extension Publisher where Output: Codable {
    func awaitAndTrack(exit: @escaping (ExitStatus) -> Void, cancellables: inout Set<AnyCancellable>) {
        sink { (completion: Subscribers.Completion<Self.Failure>) in
            if case .failure(let error) = completion {
                track(error)
                exit(.failure)
            }
        } receiveValue: { (value: Output) in
            track(value)
            exit(.success)
        }
        .store(in: &cancellables)
    }
}
