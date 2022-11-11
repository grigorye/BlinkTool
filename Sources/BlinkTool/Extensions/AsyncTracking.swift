func track<T: Codable>(body: () async throws -> T) async throws {
    do {
        let value = try await body()
        track(value)
    } catch {
        track(error)
        throw error
    }
}

func track<T: Codable>(body: @autoclosure () async throws -> T) async throws {
    do {
        let value = try await body()
        track(value)
    } catch {
        track(error)
        throw error
    }
}

func track<T>(body: () async throws -> T) async throws where T: AsyncSequence, T.Element: Codable {
    do {
        for try await i in try await body() {
            track(i)
        }
    } catch {
        track(error)
        throw error
    }
}
