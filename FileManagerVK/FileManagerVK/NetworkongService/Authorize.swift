//
//  Authorize.swift
//  FileManagerVK
//
//  Created by Станислав on 28.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

class  Authorize {
    
    
    func  getRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
            components.host = "oauth.vk.com"
            components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7437299"),
            URLQueryItem(name: "scope", value: "131075"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.103")
        ]
        
        guard let url = components.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
}
