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
    private let sessionApp: SessionApp
    private let appConfiguration: Configuration
    
    init(sessionApp: SessionApp, appConfiguration: Configuration){
        self.sessionApp = sessionApp
        self.appConfiguration = appConfiguration
    }
    
    func loadFiles( onComplete: @escaping ([FileModel]) -> Void, onError: @escaping (Error) -> Void){
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = appConfiguration.scheme
        urlConstructor.host = appConfiguration.host
        
        urlConstructor.path = "/method/docs.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "count", value: "0"),
            URLQueryItem(name: "type", value: "0"),
            URLQueryItem(name: "access_token", value: sessionApp.token),
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
        
        urlConstructor.scheme = appConfiguration.scheme
        urlConstructor.host = appConfiguration.host
        
        urlConstructor.path = "/method/docs.edit"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "doc_id", value: "\(id)"),
            URLQueryItem(name: "title", value: "\(name)"),
            URLQueryItem(name: "access_token", value: sessionApp.token),
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
        
        urlConstructor.scheme = appConfiguration.scheme
        urlConstructor.host = appConfiguration.host
        
        urlConstructor.path = "/method/docs.delete"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(file.ownerID)"),
            URLQueryItem(name: "doc_id", value: "\(file.id)"),
            URLQueryItem(name: "access_token", value: sessionApp.token),
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
    
    func downloadFile(_ file: FileModel, isUserInitiated: Bool, completion: @escaping (_ success: Bool,_ filrLocation: URL?) -> Void){
        
        let fileURL = URL(string: file.url)
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationURL = documentDirectoryURL.appendingPathComponent("\(file.id)" + "." + "\(file.ext)" )
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
                debugPrint("Файл уже был загружен")
                completion(true, destinationURL) 
        } else if isUserInitiated {
            URLSession.shared.downloadTask(with: fileURL!, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: tempLocation, to: destinationURL)
                        completion(true, destinationURL)
                        print("Файл загружен")
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false,nil)
                }
            }).resume()
        }
    }
    
}
