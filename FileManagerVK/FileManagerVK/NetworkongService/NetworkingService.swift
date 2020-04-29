//
//  NetworkingService.swift
//  FileManagerVK
//
//  Created by Станислав on 28.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

enum ServerError: Error {
    case noDataProvided
    case filedToDecode
    case errorTask
}

class NetworkingService {
    
    
    func loadFiles( onComplete: @escaping ([FileModel]) -> Void, onError: @escaping (Error) -> Void){
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        
        urlConstructor.host = "api.vk.com"
        
        urlConstructor.path = "/method/docs.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "count", value: "0"),
            URLQueryItem(name: "type", value: "0"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.103"),
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            if error != nil {
                onError(ServerError.errorTask)
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            
            guard let files = try? JSONDecoder().decode(FilesResponse.self, from: data).response.items else {
                onError(ServerError.filedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(files)
            }
            
        }
        task.resume()
    }
    
    func editFile(id: Int, newName name: String, onComplete: @escaping () -> Void, onError: @escaping (Error) -> Void){
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        
        urlConstructor.host = "api.vk.com"
        
        urlConstructor.path = "/method/docs.edit"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "doc_id", value: "\(id)"),
            URLQueryItem(name: "title", value: "\(name)"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.103"),
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            if error != nil {
                onError(ServerError.errorTask)
            }
            
            if response != nil {
                DispatchQueue.main.async {
                    onComplete()
                }
            }
        }
        task.resume()
    }
    
    func deleteFile(file: FileModel, onComplete: @escaping () -> Void, onError: @escaping (Error) -> Void){
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        
        urlConstructor.host = "api.vk.com"
        
        urlConstructor.path = "/method/docs.delete"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(file.ownerID)"),
            URLQueryItem(name: "doc_id", value: "\(file.id)"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.103"),
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            if error != nil {
                onError(ServerError.errorTask)
            }
            
            if response != nil {
                DispatchQueue.main.async {
                    onComplete()
                }
            }
        }
        task.resume()
    }
}
