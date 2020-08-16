//
//  NavigationBar.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func configure(type: TypeNavigationBar) {
        switch type {
        case .standart:
            setStandartStyle()
        }
    }
    
    private func setStandartStyle(){
        
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .default
        navigationBar.backgroundColor = GeneralColor.backgroundColor.uiColor()
        navigationBar.barTintColor = GeneralColor.backgroundColor.uiColor()
        navigationBar.largeTitleTextAttributes = [.foregroundColor: GeneralColor.textColor.uiColor()]
        navigationBar.titleTextAttributes = [.foregroundColor: GeneralColor.textColor.uiColor()]
        navigationBar.tintColor = GeneralColor.activeTextColor.uiColor()
        view.backgroundColor = GeneralColor.backgroundColor.uiColor()
        
    }
    
    enum TypeNavigationBar {
        case standart
    }
}

