import Foundation

//var available = false
//
//var conditon = pthread_cond_t()
//var mutex = pthread_mutex_t()
//
////когда мы создадим экземпляр это будет у нас отдельный поток
//class ConditionMutexPrinter : Thread {
//
//    override init() {
//        pthread_cond_init(&conditon, nil)
//        pthread_mutex_init(&mutex, nil)
//    }
//    override func main() {
//        printerMethod()
//    }
//
//    private func printerMethod() {
//        pthread_mutex_lock(&mutex)
//        print("Попали в принтер")
//        while (!available) {
//            print("Принтер ждет")
//            pthread_cond_wait(&conditon, &mutex) //спит
//            print("Принтер дождался")
//        }
//        available = false
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//        print("Ушли из принтера")
//    }
//}
//
//
////а это второй поток
//class ConditionMutexWriter : Thread {
//
//    override init() {
//        pthread_cond_init(&conditon, nil)
//        pthread_mutex_init(&mutex, nil)
//    }
//    override func main() {
//        writerMethod()
//    }
//
//    private func writerMethod() {
//        pthread_mutex_lock(&mutex)
//        print("Попали в врайтер")
//        available = true
//        pthread_cond_signal(&conditon)
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//        print("Ушли из врайтера")
//    }
//}
//
//
//let conditionPrinter = ConditionMutexPrinter()
//let conditionWriter = ConditionMutexWriter()
////вызываем потоки
//conditionWriter.start()
//conditionPrinter.start()
////conditionWriter.start()



//MARK: -теперь с NSCondition
//let nsCondition = NSCondition()
//var isAvailable = false
//
//class WriterThtread : Thread {
//    override func main() {
//        nsCondition.lock() // протокол NSLocking
//        print("Зашли в читатель")
//        isAvailable = true
//        nsCondition.signal()
//        nsCondition.unlock()
//        print("Вышли из читателя")
//    }
//}
//
//class PrintThread : Thread {
//
//    override func main() {
//        nsCondition.lock()
//        print("Вошли в принтер")
//        while !isAvailable {
//            nsCondition.wait() //возвращаемся сюда, когда у кондишена сработал сигнал
//        }
//        isAvailable = false
//        defer {
//            nsCondition.unlock()
//        }
//        print("Вышли из принтера")
//    }
//}
//let writer = WriterThtread()
//let printer = PrintThread()
//print("\nNew pair of threads : \n")
//writer.start()
//printer.start()




//func printTimeElapsedWhenRunningCode(title:String, operation:(String)->(String)) {
//    let startTime = CFAbsoluteTimeGetCurrent()
//    operation(Strin)
//    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
//    print("Time elapsed for \(title): \(timeElapsed)



//MARK: -Сделать так, чтобы из полученного текста вышел текст с сначала нечетными, потом с четными его строками
let nsCondition = NSCondition()
let nsConditionForPrint = NSCondition()


func reverse(string : String) -> String {
    var array = [Character]()
    for char in string {
        array.insert(char, at: 0)
    }
    return String(array)
}

func reverse2(string : inout String) {
    var array = Array(string)
    array.reverse()
    string = String(array)
}




//введем переменную, которая будет условием, что можно записывать четные
var canWriteEvenString = false
//введем перемнную, которая будет условием, что можно печатать
var canPrint = false
var globalFinishArrayOddAndEven = [String]()

class threadForOdd : Thread {
    var arrayOfOdd = [String]()
    init(arrayOfOdd : [String]) {
        self.arrayOfOdd = arrayOfOdd
    }
    
    override func main() {
        nsCondition.lock()
        print("Вошли в thread для нечетных")
        for i in 0..<arrayOfOdd.count {
            reverse2(string: &arrayOfOdd[i])
        }
        globalFinishArrayOddAndEven.append(contentsOf: arrayOfOdd)
        canWriteEvenString = true
        nsCondition.signal()
        defer {
            nsCondition.unlock()
        }
        print("Вышли из thread для нечетных")
    }
}

//Хочу, чтобы сначала нечетные строки, потом четные
class threadForEven : Thread {
    var arrayOfEven = [String]()
    init(arrayOfEven : [String]) {
        self.arrayOfEven = arrayOfEven
    }
    
    override func main() {
        nsCondition.lock()
        print("Вошли в thread для четных")
        for i in 0..<arrayOfEven.count {
            reverse2(string: &arrayOfEven[i])
        }
        //Внизу условие не работает, потому что на момент этой проверки в массив уже может что-то записаться (они же параллельные)
//        while globalFinishArrayOddAndEven.count == 0 {
//            nsCondition.wait() //ждем сигнала
//        }
        while !canWriteEvenString {
            nsCondition.wait()
        }
        globalFinishArrayOddAndEven.append(contentsOf: arrayOfEven)
        canPrint = true
        nsConditionForPrint.signal() // вопрос нужен ли другой NSCondition? Проверить (Ответ:да)

        defer {
            nsCondition.unlock()
        }
        print("Вышли из thread для четных")
    }
}


//теперь печатающий тред
class PrintThread : Thread {
    override func main() {
        nsConditionForPrint.lock()
        print("Вошли в печатание")
        while !canPrint {
            nsConditionForPrint.wait()
        }
        print(globalFinishArrayOddAndEven)
        defer {
            nsConditionForPrint.unlock()
        }
        
        
        print("Вышли из печатания")
    }
}


let documentsURL = NSURL(
  fileURLWithPath: NSSearchPathForDirectoriesInDomains(
    .desktopDirectory, .allDomainsMask, true).first!,
  isDirectory: true
)

let URLToMyFile = documentsURL.appendingPathComponent("text.txt")



//хотим нечетные строки отправить в один массив, а четные в другой
//хотя на самом деле в один поток, а четные в другой

var arrayForOdd = [String]()
var arrayForEven = [String]()

if let path = URLToMyFile?.path {
    do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let arrayText = data.components(separatedBy: .newlines)
        for i in 0..<arrayText.count {
            i%2 == 0 ? arrayForOdd.append(arrayText[i]) : arrayForEven.append(arrayText[i])
        }
        //print(arrayForOdd)
    } catch {
        print(error)
    }
}

let printText = PrintThread()
let evenWriterThread = threadForEven(arrayOfEven: arrayForEven)
let oddWriterThread = threadForOdd(arrayOfOdd: arrayForOdd)

printText.start()
evenWriterThread.start()
oddWriterThread.start()




//MARK: -проверка, какая из функций работает быстрее
var string = "111111111111111111111111111111111qwerty1111111111111111111111111111111111111111111122222222222222222222222222222222222222222222222222222qwerty22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222223333333333333333333333333333333333333333333333333333qwerty33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333334444444444444444444444444444444444444444444444444444qwerty44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444555555555555555555555555555555555555555555555555555555555555qwerty5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555666666666666666666666666666666666666666666666qwerty666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666"
let startTime = CFAbsoluteTimeGetCurrent()
reverse(string: string)


let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print(timeElapsed)




let startTime2 = CFAbsoluteTimeGetCurrent()

reverse2(string: &string)

let timeElapsed2 = CFAbsoluteTimeGetCurrent() - startTime2
print(timeElapsed2)
