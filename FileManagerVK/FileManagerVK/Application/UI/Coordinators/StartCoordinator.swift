//
//  StartCoordinator.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

final class StartCoordinator: BaseCoordinator {
    
    var finishFlow: BoolClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        showSplash()
    }
    
    private func showSplash() {
        let splashScreen = screenFactory.makeSplashScreen()
        splashScreen.isAuthorize = { [weak self] isAuthtorize in
            if isAuthtorize {
                self?.finishFlow?(true)
            } else {
                self?.showAuthtorizationScreen()
            }
        }
        router.setRootModule(splashScreen, hideBar: true)
    }
    
    private func showAuthtorizationScreen() {
        let authtorizationScreen = screenFactory.makeAuthtorizationScreen()
        authtorizationScreen.moveToAuthorize = { [weak self] in
            self?.showWebAuth()
        }
        router.setRootModule(authtorizationScreen, hideBar: true)
    }
    
    private func showWebAuth() {
        let webAuthScreen = screenFactory.makeWebAuthScreen()
        webAuthScreen.tokenReceived = { [weak self] in
            self?.finishFlow?(true)
        }
        router.push(webAuthScreen)
    }
}
