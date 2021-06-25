import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


class OperationCancellTest : Operation {
    override func main() {
        if isCancelled {
            print("Стоп")
            return
        }
        print("Далее")
        sleep(2)
        if isCancelled {
            print("Стоп")
            return
        }
        print("Далее")
    }
}
let operationQueue = OperationQueue()
func cancellMethod() {
    let testCancell = OperationCancellTest()
    operationQueue.addOperation(testCancell)
    testCancell.cancel()
}

//cancellMethod()


class WaitOperationTest : Operation {
    private let opQueue = OperationQueue()
    
    func test() {
        opQueue.addOperation {
            
            sleep(1)
            print("test 1")
        }
        opQueue.addOperation {
            
            sleep(2)
            print("test 2")
        }
        opQueue.waitUntilAllOperationsAreFinished() //барьер
        opQueue.addOperation {
            print("test 3")
        }
        opQueue.addOperation {
            print("test 4")
        }
    }
}

let waitOperationTest = WaitOperationTest()
//waitOperationTest.test()

class WaitOperationTest2 : Operation {
    private let opQueue = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation {
            sleep(1)
            print("test 1")
        }
        let operation2 = BlockOperation {
            sleep(2)
            print("test 2")
        }
        
        opQueue.addOperations([operation1, operation2], waitUntilFinished: true)
        opQueue.addOperation {
            print("test 4")
        }
    }
}
let waitOperationTest2 = WaitOperationTest2()
//waitOperationTest2.test()



class CompletionBlockTest : Operation {
    private let opQueue = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation {
            sleep(2)
            print("CompletionBlock Test")
        }
        operation1.completionBlock = { //он после основного
            sleep(3)
            print("finish with completionBlock")
        }
        let operation2 = BlockOperation {
            sleep(1)
            print("CompletionBlock Test 2")
        }
        operation2.completionBlock = {
            print("finish with completionBlock 2")
        }
        opQueue.addOperation(operation1)
        opQueue.addOperation(operation2)
    }
}

let completionBlockTest = CompletionBlockTest()
completionBlockTest.test()
