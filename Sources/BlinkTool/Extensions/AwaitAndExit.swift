import Dispatch

#if os(Linux)
import Glibc
#else
import Darwin
#endif

func await(block: (_ exit: @escaping () -> Void) -> Void) {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    block {
        dispatchGroup.leave()
    }
    dispatchGroup.notify(queue: DispatchQueue.main) {
        exit(EXIT_SUCCESS)
    }
    dispatchMain()
}
