//
//  AuthtorizationVC.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

import UIKit

final class AuthtorizationVC<View: AuthtorizationView>: BaseViewController<View>, AutorizationViewDelegate {

    var moveToAuthorize: VoidClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.animateTitleLabel()
    }
    
    func moveToRegistrationWebView() {
        moveToAuthorize?()
    }
}
