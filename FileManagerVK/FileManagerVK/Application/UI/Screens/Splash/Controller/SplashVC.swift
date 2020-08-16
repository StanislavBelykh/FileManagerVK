//
//  SplashVC.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

final class SplashVC<View: SplashViewImpl>: BaseViewController<View> {
    
    var isAuthorize: BoolClosure?
    
    private let sessionApp: SessionApp
    
    init(sessionApp: SessionApp) {
        self.sessionApp = sessionApp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lifeTimeToken = sessionApp.lifeTimeToken, lifeTimeToken > 600 {
            isAuthorize?(true)
        } else {
            isAuthorize?(false)
        }
    }
}
