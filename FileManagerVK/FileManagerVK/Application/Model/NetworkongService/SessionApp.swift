//
//  Session.swift
//  FileManagerVK
//
//  Created by Станислав on 28.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

class SessionApp {
    
//    static var shared = SessionApp()
    var token: String? = UserDefaults.standard.string(forKey: "token")
    var userID: Int?
}
