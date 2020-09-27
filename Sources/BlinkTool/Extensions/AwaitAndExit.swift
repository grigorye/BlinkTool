import Darwin
import Dispatch

func await(block: (_ exit: @escaping () -> Void) -> Void) {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    block {
        dispatchGroup.leave()
    }
    dispatchGroup.notify(queue: DispatchQueue.main) {
        Darwin.exit(EXIT_SUCCESS)
    }
    dispatchMain()
}
