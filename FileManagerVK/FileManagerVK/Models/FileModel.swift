//
//  FileModel.swift
//  FileManagerVK
//
//  Created by Станислав on 22.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

enum TypeFile: Int {
    case textDocument = 1
    case archiv = 2
    case gif = 3
    case image = 4
    case audio = 5
    case video = 6
    case book = 7
    case Uncknow = 8
    
    func getName() -> String {
        switch self.rawValue {
        case 1 :
            return "Text Document" //— текстовые документы;
        case 2 :
            return "Archiv"        //— архивы;
        case 3 :
            return "Gif"           //— gif;
        case 4 :
            return "Image"         //— изображения;
        case 5 :
            return "Audio"         //— аудио;
        case 6 :
            return "Video"         //— видео;
        case 7 :
            return "Book"          //— электронные книги;
        default:
            return "Uncknow"       //— неизвестно.
        }
    }
}

struct FileModel {
    let id: String
    let owner_id: Int
    let title: String
    let size: Int
    let ext: String
    let url: String
    let date: Date
    let type: TypeFile
    let preview: Preview
    
}
struct  Preview {
    let photo: Size
}
struct Size {
    let sizeS: String
    let sizeM: String
    let sizeL: String
}
//id": 437608344,
//"owner_id": -37273781,
//"title": "test",
//"size": 136266,
//"ext": "png",
//"url": "https://vk.com/do...2118df3d1&api=1",
//"date": 1467272719,
//"type": 4,
//"preview": {
//          "photo": {
//                      "sizes":
