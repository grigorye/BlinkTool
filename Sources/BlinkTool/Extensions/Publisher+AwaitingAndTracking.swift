import Combine

extension Publisher where Output: Codable {
    func awaitAndTrack(exit: @escaping () -> Void, cancellables: inout Set<AnyCancellable>) {
        sink { (completion: Subscribers.Completion<Self.Failure>) in
            if case .failure(let error) = completion {
                track(error)
            }
            exit()
        } receiveValue: { (value: Output) in
            track(value)
        }
        .store(in: &cancellables)
    }
}
