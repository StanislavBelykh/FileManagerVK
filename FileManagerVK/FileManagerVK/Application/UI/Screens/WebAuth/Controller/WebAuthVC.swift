//
//  WebAuthVC.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit
import WebKit

final class WebAuthVC<View: WKWebView>: BaseViewController<View>, WKNavigationDelegate {
    
    var tokenReceived: VoidClosure?
    
    private let sessionApp: SessionApp
    private let authService: Authorize
    
    init(sessionApp: SessionApp, authService: Authorize) {
        self.sessionApp = sessionApp
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.navigationDelegate = self
        
        if let request = authService.getRequest(){
            rootView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce ([String:String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        guard let token = params["access_token"] else { return }
        sessionApp.token = token
        UserDefaults.standard.setValue(token, forKey: "token")
        
        tokenReceived?()
        
        decisionHandler(.cancel)
    }
}
