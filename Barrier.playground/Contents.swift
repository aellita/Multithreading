import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// в serial queue добавляется сначала один элемент, потом 3,4, ничего не грозит
//всегда 10 элементов
var array = [Int]()
for i in 0..<10 {
    array.append(i)
}
print(array)
print(array.count)


var array2 = [Int]()

DispatchQueue.concurrentPerform(iterations: 10) { (ind) in
    array2.append(ind)
}
//тут одновременно записывается, race condition, выходит одновременная запись
//не недописал, нет сымсла ждать, уже он такой выходит
print(array2)
print(array2.count)
DispatchQueue.main.async {
    sleep(4)
    print(array2)
    print(array2.count)
}


class SaveArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "Hi", attributes: .concurrent)
    
    //защитили запись
    public func writeVal(_ value : T) {
        print("her")
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }
    
    //защитили чтение
    public var resultArr : [T] {
        print("here1")
        var result = [T]()
        queue.async {
            result = self.array
        }
        return result
    }
}
var arraySafe = SaveArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { (ind) in
    arraySafe.writeVal(ind)
}
print(arraySafe.resultArr)


DispatchQueue.concurrentPerform(iterations: 10) { (ind) in
    arraySafe.writeVal(ind)
}




private let concurrentQueue = DispatchQueue(label: "com.gcd.dispatchBarrier", attributes: .concurrent)
for value in 1...5 {
    concurrentQueue.async() {
        print("async \(value)")
    }
}
for value in 6...10 {
    concurrentQueue.async(flags: .barrier) {
        print("barrier \(value)")
    }
}
for value in 11...15 {
    concurrentQueue.sync() {
        print("sync \(value)")
    }
}

