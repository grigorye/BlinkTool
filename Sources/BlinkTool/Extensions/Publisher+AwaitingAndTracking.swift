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
            switch completion {
            case .failure(let error):
                track(error)
                exit(.failure)
            case .finished:
                exit(.success)
            }
        } receiveValue: { (value: Output) in
            track(value)
        }
        .store(in: &cancellables)
    }
}
