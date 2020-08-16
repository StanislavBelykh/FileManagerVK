//
//  DI.swift
//  IOSDevJobs
//
//  Created by Станислав Белых on 19.07.2020.
//  Copyright © 2020 Станислав Белых. All rights reserved.
//

import UIKit
import WebKit

final class Di {
    
    fileprivate let sessionApp: SessionApp
    fileprivate let authConfiguration: AuthConfiguration
    fileprivate let appConfiguration: Configuration
    fileprivate let networkingService: NetworkingService
    fileprivate let authService: Authorize
    fileprivate let sortManager: SortManager
    fileprivate let screenFactory: ScreenFactoryImpl
    fileprivate let coordinatorFactory: CoordinatorFactoryImpl
    
     
    init() {
        sessionApp = SessionApp()
        authConfiguration = AppAuthConfiguration()
        appConfiguration = AppConfiguration()
        sortManager = SortManager()
        networkingService = NetworkingService(sessionApp: sessionApp, appConfiguration: appConfiguration)
        authService = Authorize(authConfiguration: authConfiguration)
        screenFactory = ScreenFactoryImpl()
        coordinatorFactory = CoordinatorFactoryImpl(screenFactory: screenFactory)

        screenFactory.di = self
    }
}

protocol AppFactory {
    func makeKeyWindowWithCoordinator() -> (UIWindow, Coordinator)
    
}

extension Di: AppFactory {
    
    func makeKeyWindowWithCoordinator() -> (UIWindow, Coordinator) {
        let window = UIWindow()
        let rootVC = UINavigationController()
        rootVC.configure(type: .standart)
        rootVC.navigationBar.prefersLargeTitles = true
        let router = RouterImp(rootController: rootVC)
        let cooridnator = coordinatorFactory.makeApplicationCoordinator(router: router)
        window.rootViewController = rootVC
        return (window, cooridnator)
    }
    
}

protocol ScreenFactory {

    func makeSplashScreen() -> SplashVC<SplashViewImpl>
    func makeAuthtorizationScreen() -> AuthtorizationVC<AuthtorizationViewImpl>
    func makeWebAuthScreen() -> WebAuthVC<WKWebView>
    func makeFileListScreen() -> FileListVC<FileListViewImpl>
}

final class ScreenFactoryImpl: ScreenFactory {
    
    fileprivate weak var di: Di!
    fileprivate init(){}
    
    func makeSplashScreen() -> SplashVC<SplashViewImpl> {
        return SplashVC<SplashViewImpl>(sessionApp: di.sessionApp)
    }
    
    func makeAuthtorizationScreen() -> AuthtorizationVC<AuthtorizationViewImpl> {
        return AuthtorizationVC<AuthtorizationViewImpl>()
    }
    
    func makeWebAuthScreen() -> WebAuthVC<WKWebView> {
        return WebAuthVC<WKWebView>(sessionApp: di.sessionApp, authService: di.authService)
    }
    
    func makeFileListScreen() -> FileListVC<FileListViewImpl> {
        return FileListVC<FileListViewImpl>(networkingService: di.networkingService, sortManager: di.sortManager)
    }
}

protocol CoordinatorFactory {
    
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator
    func makeStartCoordinator(router: Router) -> StartCoordinator
    func makeFileListCoordinator(router: Router) -> FileListCoordinator
}

final class CoordinatorFactoryImpl: CoordinatorFactory {

    private let screenFactory: ScreenFactory
    
    fileprivate init(screenFactory: ScreenFactory){
        self.screenFactory = screenFactory
    }
    
    func makeApplicationCoordinator(router: Router) -> ApplicationCoordinator {
        return ApplicationCoordinator(router: router, coordinatorFactory: self)
    }
    
    func makeStartCoordinator(router: Router) -> StartCoordinator {
        return StartCoordinator(router: router, screenFactory: screenFactory)
    }
    
    func makeFileListCoordinator(router: Router) -> FileListCoordinator {
        return FileListCoordinator(router: router, screenFactory: screenFactory)
    }
}
