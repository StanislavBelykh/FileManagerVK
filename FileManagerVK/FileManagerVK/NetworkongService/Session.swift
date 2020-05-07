//
//  Session.swift
//  FileManagerVK
//
//  Created by Станислав on 28.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

class Session {
    
    static var shared = Session()
    var token: String?
    var userID: Int?
    
    private init() {
        
    }
}
