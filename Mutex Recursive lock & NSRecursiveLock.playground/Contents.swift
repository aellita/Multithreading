import Foundation
//другая блокировка
//NSRecursiveLock -- чуть изменили NSLock


//тут создаем один тред, он не блокируется навсегда, потому что в аттрибуте сет тайп RECURSIVE
class RecursiveMutexTest {
    private var mutex = pthread_mutex_t()
    private var attribute = pthread_mutexattr_t()
     
    init() {
        pthread_mutexattr_init(&attribute)
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribute)
    }
    
    func firstTask() {
        pthread_mutex_lock(&mutex)
        secondTask()
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    func secondTask() {
        pthread_mutex_lock(&mutex)
        print("Second")
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
}


let recursive = RecursiveMutexTest()
recursive.firstTask()



// Все то же самое, но с другой оболочкой
let recursiveLock = NSRecursiveLock()

class RecursiveThread : Thread { // поток
    
    override func main() {
        recursiveLock.lock()
        print("1 Lock was worked")
        call()
        defer {
            recursiveLock.unlock()
        }
        print("Exit main")
    }
    
    func call() {
        recursiveLock.lock()
        print("2 Lock was worked")
        defer {
            recursiveLock.unlock()
        }
        print("Exit call")

    }
}

let thread = RecursiveThread()
thread.start()
