import Cocoa

var greeting = "Hello, playground"

class ReadWriteLock : Thread {
    private var lock = pthread_rwlock_t()
    private var attr = pthread_rwlockattr_t()
    
    //общий ресурс
    private var globalPlroperty = [Int]() //crit sec
    
    override init() {
        pthread_rwlock_init(&lock, &attr)
    }
    
    public var workProperty : Int? {
        get {
            pthread_rwlock_wrlock(&lock)
            print("reading")
            let temp = globalPlroperty
            pthread_rwlock_unlock(&lock)
            if temp.isEmpty {
                return nil
            }
            return temp[0]
            
        }
        set {
            pthread_rwlock_rdlock(&lock)
            print("\n+ \(newValue!)")
            globalPlroperty.append(newValue!)
            pthread_rwlock_unlock(&lock)
        }
    }
}

let a = ReadWriteLock()

a.start()

print(a.workProperty)
print(a.workProperty)
a.workProperty = 9
a.workProperty = 99
print(a.workProperty)
print(a.workProperty)



class SpinLock {
    private var lock = OS_SPINLOCK_INIT
    
    func some() {
        OSSpinLockLock(&lock)
        //something //он постоянно спрашивает ресурс освободился ли как while
        OSSpinLockUnlock(&lock)
    }
}

//вместо SpinLock
class UnfairLock {
    private var lock = os_unfair_lock_s()
    var array = [Int]()
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
}

//есть в foundation
class SynchronizedObjC {
    private let lock = NSObject()
    
    var array = [Int]()
    func some() {
        objc_sync_enter(lock)
        array.append(1)
        objc_sync_exit(lock)
    }
}
