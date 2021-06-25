import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//
//
//let queue = DispatchQueue(label: "Me", attributes: .concurrent)
//
//let semaphore = DispatchSemaphore(value: 0) //в этой очереди может проходить два потока, как в магазин, по два в одной очереди
//
//semaphore.signal()
//queue.async {
//    semaphore.wait() // -1
//    sleep(3)
//    print("method 1")
//    semaphore.signal() // +1
//}
//
//queue.async {
//    semaphore.wait() // -1
//    sleep(3)
//    print("method 2")
//    semaphore.signal() // +1
//}
//
//queue.async {
//    semaphore.wait() // -1
//    sleep(3)
//    print("method 3")
//    semaphore.signal() // +1
//}
//
//
//let sem = DispatchSemaphore(value: 0)
//sem.signal()
//DispatchQueue.concurrentPerform(iterations: 10) { (id : Int) in
//    sem.wait(timeout: .distantFuture) //ожидание будущего
//    sleep(1)
//    print("Block", String(id))
//    sem.signal()
//}


class SemaphoreTest {
    private let semaphore = DispatchSemaphore(value: 4)
    private var array = [Int]()
    
    private func method(_ id: Int) {
        semaphore.wait() //-1
        
        array.append(id)
        print("test array", array.count)
        Thread.sleep(forTimeInterval: 1)
        
        semaphore.signal() //+1
    }
    
    func startAllThreads() {
        DispatchQueue.global().async {
            self.method(111)
            
        }
        DispatchQueue.global().async {
            self.method(144)
            
        }
        DispatchQueue.global().async {
            self.method(11551)
            
        }
        DispatchQueue.global().async {
            self.method(2)
            
        }
    }
}

let semaphoreTest = SemaphoreTest()
semaphoreTest.startAllThreads()
