//
//  ColorScheme.swift
//  FileManagerVK
//
//  Created by Станислав Белых on 15.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//
import UIKit

enum ColorSchemeOption {
    case dark
    case light
}
struct SchemeColor {
    
    let dark: UIColor
    let light: UIColor

    func uiColor() -> UIColor {
        return colorWith(scheme: ColorScheme.shared.schemeOption)
    }
    
    func cgColor() -> CGColor {
        return uiColor().cgColor
    }
    
    private func colorWith(scheme: ColorSchemeOption) -> UIColor {
        switch scheme {
        case .dark: return dark
        case .light: return light
        }
    }

    // ColorScheme
    struct ColorScheme {
        
        static let shared = ColorScheme()
        private (set) var schemeOption: ColorSchemeOption
        
        private init() {
            
            if #available(iOS 13.0, *) {
                let interfaceStyle = UITraitCollection.current.userInterfaceStyle
                
                switch interfaceStyle {
                case .dark:
                    self.schemeOption = .dark
                default:
                    self.schemeOption = .light
                }
            } else {
                
                self.schemeOption = .light
            }
            
        }
    }
}
