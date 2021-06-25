import Foundation

class SaveTread {
    private var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    //защита объекта и его разблокировка
    func someMethod(completion : () -> ()) {
        pthread_mutex_lock(&mutex)
        completion() //  -- защищенное от других потоков
        //some data
        //если вдруг выше что-то случится, то поток не разблокируется
        //используем defer чтоб гарантировать освобждение объекта
        defer {
            pthread_mutex_unlock(&mutex)
        }
        print("bye")
        //pthread_mutex_unlock(&mutex)
    }
}

var array = [String]()
let saveTread = SaveTread()

saveTread.someMethod {
    print("test")
    array.append("1 thread")
}

array.append("2 thread")



class anotherSaveClass : NSLock {
    private let lockMutex = NSLock()
    
    func anotherMethod(completion : ()->()) {
        lockMutex.lock()
        lockMutex.lock() // при вызове дважды навсегда блокируется (отн к NSLock) STARVATION
        completion()
        defer {
            lockMutex.unlock()
        }
    }
}

var array2 = [String]()
let saveTread2 = anotherSaveClass()

saveTread2.anotherMethod {
    print("test")
    array2.append("1 thread")
}

array.append("2 thread")
