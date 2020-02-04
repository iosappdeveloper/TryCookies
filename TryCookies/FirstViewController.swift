//
//  FirstViewController.swift
//  TryCookies
//
//  Created by Matoria, Ashok on 03/02/20.
//  Copyright © 2020 Matoria, Ashok. All rights reserved.
//

import UIKit
import WebKit
import Commons
import UICommons

class FirstViewController: UIViewController {
    @IBOutlet weak var launchButton: UIButton!
    
    @IBAction func tapLaunchButton(_ sender: Any) {
        UserDefaults.standard.clearCookies()
        
        let createCookiesVC = CreateCookieHybridViewController()
        navigationController?.pushViewController(createCookiesVC, animated: true)
    }
}

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

extension UserDefaults {
    private var cookiesKey: String {
        return "cookies"
    }
    
    func saveCookies(_ cookies: [HTTPCookie]) {
        var cookieProperties = [[HTTPCookiePropertyKey: Any]]()
        cookies.forEach { cookieProperties.append($0.properties!) }
        UserDefaults.standard.setValue(cookieProperties, forKey: cookiesKey)
        let success = UserDefaults.standard.synchronize()
        assert(success)
    }
    
    func getCookies() -> [HTTPCookie] {
        var savedCookies = [HTTPCookie]()
        guard let cookiesValue = UserDefaults.standard.value(forKey: cookiesKey) else { return savedCookies }
        guard let cookieProperties = cookiesValue as? [[HTTPCookiePropertyKey: Any]] else { return savedCookies }
        cookieProperties.forEach {
            if let cookie = HTTPCookie(properties: $0) {
                savedCookies.append(cookie)
            }
        }
        return savedCookies
    }
    
    func clearCookies() {
        setValue(nil, forKey: cookiesKey)
        synchronize()
    }
}

struct Environment {
    static let host = "google.com"//"sc8lqmt01.plateau.com"
    static let authWebPagePath = ""//"/learning/user/nativelogin.jsp"
    static let authSuccessInterceptorPath = "/"//"/learning/user/personal/landOnPortalHome.do"
    static let homeWebPagePath = "/mail"//"/learning/user/personal/landOnPortalHome.do"
    
    static let authWebPageUrl: URL = {
        return absoluteUrl(Environment.authWebPagePath)
    }()
    
    static let homeWebPageUrl: URL = {
        return absoluteUrl(Environment.homeWebPagePath)
    }()
    
    private static func absoluteUrl(_ path: String) -> URL {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = Environment.host
        comp.path = path
        return comp.url!
    }
}
