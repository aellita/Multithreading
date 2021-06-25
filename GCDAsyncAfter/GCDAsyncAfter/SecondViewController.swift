//
//  SecondViewController.swift
//  GCDAsyncAfter
//
//  Created by Аэлита Лукманова on 17.06.2021.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        for i in 0..<200000 {
//            print(i)
//        }
//        DispatchQueue.concurrentPerform(iterations: 200000) { //работает 6 потоков вкл main
//            print("\($0) times")
//            print(Thread.current)
//        }
        
        //не хотим задействовать main
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async {
//            DispatchQueue.concurrentPerform(iterations: 200000) {
//                print("\($0) times")
//                print(Thread.current)
//            }
        
        myInactiveQueue()
    }
        
    func myInactiveQueue() {
        let inactiveQueue = DispatchQueue(label: "SD", attributes: [.concurrent, .initiallyInactive])
        inactiveQueue.async {
            
            print("Готово")
        }
        print("Еще не стартовала")
        inactiveQueue.activate()
        print("Стартовала")
        inactiveQueue.suspend() //попспи
        print("Пауза")
        inactiveQueue.resume()
        print("Снята с Паузы")
    }

}
