//
//  ViewController.swift
//  GCDAsyncAfter
//
//  Created by Аэлита Лукманова on 17.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        afterBlock(seconds: 2, queue: DispatchQueue.main) {
//            self.showAlert()
//            print(Thread.current)
//        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Hello", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func afterBlock(seconds : Int, queue : DispatchQueue = DispatchQueue.global(), completion: @escaping() -> ()) { //все, что попадет в это замыкание
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()                // будет отрабатывать здесь
        }
    }
    
    
}

