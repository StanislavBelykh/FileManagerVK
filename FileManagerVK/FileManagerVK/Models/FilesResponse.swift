//
//  FilesResponse.swift
//  FileManagerVK
//
//  Created by Станислав on 28.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

class FilesResponse: Codable {
    let response: Items
}
class Items: Codable {
    let items: [FileModel]
}
