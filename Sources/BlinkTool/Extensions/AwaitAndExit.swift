import Dispatch

#if os(Linux)
import Glibc
#else
import Darwin
#endif

func await(block: (_ exit: @escaping (ExitStatus) -> Void) -> Void) {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    var trackedExitStatus: ExitStatus?
    block { (exitStatus) in
        trackedExitStatus = exitStatus
        dispatchGroup.leave()
    }
    dispatchGroup.notify(queue: DispatchQueue.main) {
        switch trackedExitStatus! {
        case .success:
            exit(EXIT_SUCCESS)
        case .failure:
            exit(EXIT_FAILURE)
        }
    }
    dispatchMain()
}
