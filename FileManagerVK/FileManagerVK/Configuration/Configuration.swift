//
//  Configuration.swift
//  FileManagerVK
//
//  Created by Полина on 14.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

protocol Configuration {
    var scheme: String { get }
    var host: String { get }
}

struct AppConfiguration: Configuration {
    
    var scheme: String = "https"
    var host: String = "api.vk.com"
}
