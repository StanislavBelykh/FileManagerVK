//
//  Authorize.swift
//  FileManagerVK
//
//  Created by Станислав on 28.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

class  Authorize {
    private let authConfiguration: AuthConfiguration
    
    init(authConfiguration: AuthConfiguration) {
        self.authConfiguration = authConfiguration
    }
    func  getRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = authConfiguration.scheme
        components.host = authConfiguration.hostAuth
        components.path = authConfiguration.path
        components.queryItems = [
            URLQueryItem(name: "client_id", value: authConfiguration.clientId),
            URLQueryItem(name: "scope", value: authConfiguration.scope),
            URLQueryItem(name: "display", value: authConfiguration.displayType),
            URLQueryItem(name: "redirect_uri", value: authConfiguration.redirectUri),
            URLQueryItem(name: "response_type", value: authConfiguration.responseType),
            URLQueryItem(name: "v", value: authConfiguration.version)
        ]
        
        guard let url = components.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
}
