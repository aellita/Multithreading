//
//  AuthViewController.swift
//  YandexDiskJson
//
//  Created by Аэлита Лукманова on 19.06.2021.
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate : AnyObject {
    func handleTokenChanged(token : String)
}

class AuthViewController: UIViewController {

    weak var delegate : AuthViewControllerDelegate?
    
    private let scheme = "myphoto://"
    private let webView = WKWebView()
    private let clientID = "b026c6c7fdb34363b43f9b0c3773a373"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        guard let request = request else {
            return
        }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    private func setupViews() { 
        view.backgroundColor = .orange
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
     
    private var request : URLRequest? {
        guard var urlComponents = URLComponents(string: "https://oauth.yandex.ru/authorize") else {
            return nil
        }
        urlComponents.queryItems = [URLQueryItem(name: "response_type", value: "token"), URLQueryItem(name: "client_id", value: clientID)]
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
}

extension AuthViewController : WKNavigationDelegate {
    //захватываем эту ссылку с токеном
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
            print(url.scheme)

            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            print(targetString)
            guard let components = URLComponents(string: targetString) else { return }
            
            let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value
            if let token = token {
                print(token)
                delegate?.handleTokenChanged(token: token)
            }
            //decisionHandler(.allow)
            dismiss(animated: true, completion: nil)
        }
        print(navigationAction.request.url)
        decisionHandler(.allow)
    }
    
}
