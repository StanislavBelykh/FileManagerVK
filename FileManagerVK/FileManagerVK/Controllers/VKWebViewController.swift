//
//  VKWebViewController.swift
//  FileManagerVK
//
//  Created by Станислав on 28.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit
import WebKit

class VKWebViewController: UIViewController {
    
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view = webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        if let request = Authorize().getRequest(){
            webView.load(request)
        }
    }
}

extension VKWebViewController: WKNavigationDelegate {
    
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
      
      let token = params["access_token"]
      Session.shared.token = token!
      
      if token != nil {
        let toViewController = HomeViewController()
        navigationController?.pushViewController(toViewController, animated: true)
      }
      
      decisionHandler(.cancel)
    }
}
