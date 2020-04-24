//
//  HomeTableViewCell.swift
//  FileManagerVK
//
//  Created by Станислав on 23.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let reusedID = "HomeTableViewCell"
    
    weak var delegate: HomeTableViewCellDelegate?
    
    let imageFile: UIImageView = {
        let imageFile = UIImageView()
        imageFile.translatesAutoresizingMaskIntoConstraints = false
        imageFile.layer.cornerRadius = 5
        imageFile.clipsToBounds = true
        return imageFile
    }()
    let titleFile: UILabel = {
        let titleFile = UILabel()
        titleFile.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleFile.lineBreakMode = .byTruncatingMiddle
        titleFile.font = .boldSystemFont(ofSize: 20)
        return titleFile
    }()
    let dateFile: UILabel = {
        let dateFile = UILabel()
        dateFile.font = .systemFont(ofSize: 14)
        dateFile.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        return dateFile
    }()
    let loadButton: UIButton = {
        let loadButton = UIButton()
        if #available(iOS 13.0, *) {
            loadButton.imageView?.image = UIImage(systemName: "capslock.fill")
        } else {
            loadButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            loadButton.layer.cornerRadius = 10
            loadButton.layer.masksToBounds = true
            // Fallback on earlier versions
        }
        loadButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        return loadButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: HomeTableViewCell.reusedID)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loadFile() {
        
        delegate?.loadFile()
    }
    
}
protocol HomeTableViewCellDelegate: class {
    func loadFile()
}
