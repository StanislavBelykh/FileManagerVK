//
//  ApplicationCoordinator.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactoryImpl
    private let router: Router
    private var isLogin = false
    
    init(router: Router, coordinatorFactory: CoordinatorFactoryImpl) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        if isLogin {
            runFileListFlow()
        } else {
            runStartFlow()
        }
    }
    
    private func runStartFlow() {
        
        let coordinator = coordinatorFactory.makeStartCoordinator(router: router)
        self.addDependency(coordinator)
        coordinator.start()
        coordinator.finishFlow = { [weak self] isLogin in
            self?.isLogin = isLogin
            self?.start()
            self?.removeDependency(coordinator)
        }
    }
    
    private func runFileListFlow() {
        
        let coordinator = coordinatorFactory.makeFileListCoordinator(router: router)
        self.addDependency(coordinator)
        coordinator.start()
    }
}
