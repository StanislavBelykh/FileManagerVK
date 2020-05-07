//
//  LoginViewController.swift
//  FileManagerVK
//
//  Created by Станислав on 14.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AutorizationViewDelegate {

    let autorizationView = AutorizationView()
    
    //MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = autorizationView
        title = "Выйти"
        
        autorizationView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autorizationView.animateTitleLabel()
    }
    
    func moveToRegistrationWebView() {
        let toViewController = VKWebViewController()
        navigationController?.pushViewController(toViewController, animated: true)
    }
}
