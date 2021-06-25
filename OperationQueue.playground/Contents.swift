import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//print(Thread.current)
//
//let operation1 = { // это замыкание, не операция кью
//    print("Start")
//    print(Thread.current)
//    print("Finish")
//}
////operation1()
//let queue = OperationQueue() //сразу переводит в асинх поток
//queue.addOperation(operation1)



//print(Thread.current)
//var str : String?
//let concatOperation = BlockOperation {
//    str = "Hi" + " " + "there"
//    print(Thread.current)
//}
////concatOperation.start()
////print(Thread.current)
//let queue2 = OperationQueue()
//queue2.addOperation(concatOperation)
//sleep(2)
//print(str!)



//let queue3 = OperationQueue()
//queue3.addOperation {
//    print("queue")
//    print(Thread.current)
//}


//class MyThread : Thread {
//    override func main() {
//        print("Main Thread - не main поток")
//        print(Thread.current)
//    }
//}
//print(Thread.current)
//let myThread = MyThread()
//myThread.start()

class MyOperation : Operation { //это как блок оперейшен
    override func main() {
        print("Main Operation - не main поток")
        print(Thread.current)
    }
}
let myOperation = MyOperation()
//myOperation.start() // делает в главном потоке

let queue0 = OperationQueue()
queue0.addOperation(myOperation)
