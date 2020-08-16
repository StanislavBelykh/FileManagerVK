//
//  GeneralColor.swift
//  FileManagerVK
//
//  Created by Станислав Белых on 15.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

enum GeneralColor {
    
    static let backgroundColor = SchemeColor(dark: Dark.backgroundColor, light: Light.backgroundColor)
    static let backgroundElementColor = SchemeColor(dark: Dark.backgroundElementColor, light: Light.backgroundElementColor)
    
    //Text
    static let textColor = SchemeColor(dark: Dark.textColor, light: Light.textColor)
    
    static let subtitleTaxtColor = SchemeColor(dark: Dark.subtitleTaxtColor, light: Light.subtitleTaxtColor)
    
    static let activeTextColor = SchemeColor(dark: Dark.activeTextColor, light: Light.activeTextColor)
    
    static let buttonColor = SchemeColor(dark: Dark.buttonColor, light: Light.buttonColor)
    
    private enum Light {
        static let backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        static let backgroundElementColor = UIColor(red: 0.798, green: 0.798, blue: 0.798, alpha: 1)
        static let textColor = UIColor.black
        static let subtitleTaxtColor = UIColor.darkGray
        static let activeTextColor = UIColor.orange
        static let buttonColor = UIColor.systemBlue
    }
    
    private enum Dark {
        static let backgroundColor = UIColor.black
        static let backgroundElementColor = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 1)
        static let textColor = UIColor.white
        static let subtitleTaxtColor = UIColor.lightGray
        static let activeTextColor = UIColor.orange
        static let buttonColor = UIColor.systemBlue
    }
}
