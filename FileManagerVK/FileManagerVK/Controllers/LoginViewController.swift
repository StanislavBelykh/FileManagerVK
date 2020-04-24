//
//  LoginViewController.swift
//  FileManagerVK
//
//  Created by Станислав on 14.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AutorizationViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view = AutorizationView()
        
        view().delegate = self
        title = "Выйти"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view().animateTitleLabel()
    }
    
    func moveToRegistrationWebView() {
        let toViewController = HomeViewController()
        navigationController?.pushViewController(toViewController, animated: true)
    }
    
    func view() -> AutorizationView {
        return self.view as! AutorizationView
    }

}
