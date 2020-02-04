//
//  ConsumeCookieHybridViewController.swift
//  TryCookies
//
//  Created by Matoria, Ashok on 04/02/20.
//  Copyright © 2020 Matoria, Ashok. All rights reserved.
//

import UIKit
import WebKit
import Commons
import UICommons

class ConsumeCookieHybridViewController: UIViewController {
    var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews()
        
        load(url: Environment.homeWebPageUrl)
        // Refresh button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    }
    
    func setupSubViews() {
        Layout.add(webView, in: view)
        webView.navigationDelegate = self
    }
}

extension ConsumeCookieHybridViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url ?? "no url")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Swift.Error) {
        UIUtils.showAlert(title: error.localizedDescription)
    }
}

private extension ConsumeCookieHybridViewController {
    func load(url: URL) {
        copyCookies { [weak self] in
            self?.webView.load(URLRequest(url: url))
        }
    }
    
    func copyCookies(_ completion: @escaping () -> Void) {
        let cookies = UserDefaults.standard.getCookies()
        let dispatchGroup = DispatchGroup()
        
        // Move cookies into `httpCookieStore` of this web view before loading the url
        for cookie in cookies {
            dispatchGroup.enter()
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    @objc func refresh() {
        copyCookies { [weak self] in
            self?.webView.reload()
        }
    }
}
