//
//  AuthConfiguration.swift
//  FileManagerVK
//
//  Created by Полина on 14.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

protocol AuthConfiguration {
    var scheme: String { get }
    var hostAuth: String { get }
    var path: String { get }
    
    var clientId: String { get }
    var scope: String { get }
    var displayType: String { get }
    var responseType: String { get }
    var redirectUri: String { get }
    var version: String { get }
}

struct AppAuthConfiguration: AuthConfiguration {
    var scheme = "https"
    var hostAuth = "oauth.vk.com"
    var path = "/authorize"
    
    var clientId = "7437299"
    var scope = "131075"
    var displayType = "mobile"
    var responseType = "token"
    var redirectUri = "https://oauth.vk.com/blank.html"
    var version = "5.103"
    
}
