//
//  FileViewModelFactory.swift
//  FileManagerVK
//
//  Created by Станислав Белых on 04.11.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

final class FileViewModelFactory {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()
    
    func constructViewModels(from files: [FileModel] = [FileModel]()) -> [FileViewModel] {
        return files.compactMap { file in
            let date = Date(timeIntervalSince1970: file.date)
            let dateString = FileViewModelFactory.dateFormatter.string(from: date)
            
            return FileViewModel(
                date: dateString,
                image: UIImage(named: file.type.getIconName()),
                title: file.title,
                statusLoad: file.state
            )
        }
    }
}
