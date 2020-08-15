//
//  FileListCoordinator.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

final class FileListCoordinator: BaseCoordinator {
    
    var finishFlow: BoolClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        showFileList()
    }
    
    private func showFileList() {
        let fileListScreen = screenFactory.makeFileListScreen()
        router.setRootModule(fileListScreen, hideBar: false)
    }
}
