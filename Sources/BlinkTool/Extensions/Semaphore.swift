
actor Semaphore { // Borrowed from https://forums.swift.org/t/semaphore-alternatives-for-structured-concurrency/59353/3

    private var count: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []
    
    init(count: Int = 0) {
        self.count = count
    }
    
    func wait() async {
        count -= 1
        if count >= 0 { return }
        await withCheckedContinuation {
            waiters.append($0)
        }
    }
    
    func signal(count: Int = 1) {
        assert(count >= 1)
        self.count += count
        for _ in 0..<count {
            if waiters.isEmpty { return }
            waiters.removeFirst().resume()
        }
    }
}


extension Semaphore {
    func `do`<T>(_ body: () async throws -> T) async throws -> T {
        await self.wait()
        defer {
            self.signal()
        }
        let result = try await body()
        return result
    }
}
