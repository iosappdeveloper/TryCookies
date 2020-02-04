//
//  CreateCookieHybridViewController.swift
//  TryCookies
//
//  Created by Matoria, Ashok on 04/02/20.
//  Copyright © 2020 Matoria, Ashok. All rights reserved.
//

import UIKit
import WebKit
import Commons
import UICommons

class CreateCookieHybridViewController: UIViewController {
    var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        
        webView.load(URLRequest(url: Environment.authWebPageUrl))
    }
    
    func setupSubViews() {
        Layout.add(webView, in: view)
        webView.navigationDelegate = self
    }
}

extension CreateCookieHybridViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\(#function) >>> ", webView.url ?? "no url")
        if webView.url?.path.contains(Environment.authSuccessInterceptorPath) ?? false {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
                UserDefaults.standard.saveCookies(cookies)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Swift.Error) {
        UIUtils.showAlert(title: error.localizedDescription)
    }
}
