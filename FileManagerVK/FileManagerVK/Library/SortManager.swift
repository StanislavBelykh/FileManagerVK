//
//  SortManager.swift
//  FileManagerVK
//
//  Created by Станислав on 05.05.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

class SortManager {
    
    func sortedFor(files: [FileModel]?, by kind: TypeSorted) -> [FileModel]?{
        switch kind {
        case .date:
            return files?.sorted{ $0.date < $1.date} ?? [FileModel]()
        case .name:
            return files?.sorted{ $0.title < $1.title} ?? [FileModel]()
        case .type:
            return files?.sorted{ $0.ext < $1.ext} ?? [FileModel]()
        }
    }
    func filtredFor(files: [FileModel]?, searchText: String?) -> [FileModel]?{
        if let text = searchText?.lowercased(), searchText != "" {
            return files?.filter { (file) -> Bool in
            file.title.lowercased().contains(text)
            } ?? [FileModel]()
        } else {
            return files
        }
    }
}

enum TypeSorted {
    case type, name, date
}
