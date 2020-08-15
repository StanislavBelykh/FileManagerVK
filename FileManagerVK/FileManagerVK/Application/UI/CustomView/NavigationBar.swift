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
        navigationBar.backgroundColor = #colorLiteral(red: 0.109788619, green: 0.1098147705, blue: 0.1140848026, alpha: 1)
        navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationBar.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
    enum TypeNavigationBar {
        case standart
    }
}

