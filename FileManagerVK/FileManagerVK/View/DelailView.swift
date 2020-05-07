//
//  DelailView.swift
//  FileManagerVK
//
//  Created by Станислав on 29.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class DelailView: UIView {
    
    let preViewFile: UIImageView = {
        let preViewFile = UIImageView()
        preViewFile.image = UIImage(named: "Logo")
        preViewFile.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        preViewFile.layer.cornerRadius = 8
        preViewFile.clipsToBounds = true
        preViewFile.translatesAutoresizingMaskIntoConstraints = false
        return preViewFile
    }()
    let titleFileLable: UILabel = {
        let titleFileLable = UILabel()
        titleFileLable.translatesAutoresizingMaskIntoConstraints = false
        titleFileLable.textAlignment = .center
        
        return titleFileLable
    }()
    let dateFileLable: UILabel = {
        let dateFileLable = UILabel()
        dateFileLable.translatesAutoresizingMaskIntoConstraints = false
        return dateFileLable
    }()
    let formatFileLable: UILabel = {
        let formatFileLable = UILabel()
        formatFileLable.translatesAutoresizingMaskIntoConstraints = false
        return formatFileLable
    }()
    
}
//   let  date: Double
//   let  ext: String
//   let  id: Int
//   let  ownerID: Int
//   let  size: Int
//   let  title: String
//   let  type: TypeFile
//   let  url: String
//   let  preview: Preview?
