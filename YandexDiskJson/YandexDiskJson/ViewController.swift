//
//  ViewController.swift
//  YandexDiskJson
//
//  Created by Аэлита Лукманова on 19.06.2021.
//

import UIKit

class ViewController: UIViewController, AuthViewControllerDelegate {
    private let tableView = UITableView()
    private var token = ""
    private var isFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirst {
            updateData()
        }
        isFirst = false
    }
    
    private func setupViews() {
        self.title = "Мои фото"
        view.backgroundColor = .purple
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    

//если пустой токен, запрашиваем новый
    private func updateData() {
        guard !token.isEmpty else {
            let requestTokerViewContriller = AuthViewController()
            requestTokerViewContriller.delegate = self
            present(requestTokerViewContriller, animated: true, completion: nil)
            return
        }
        
        //load disk images
    }
}

extension ViewController {
    func handleTokenChanged(token: String) {
        self.token = token
        print(token)
        updateData()
    }
}
