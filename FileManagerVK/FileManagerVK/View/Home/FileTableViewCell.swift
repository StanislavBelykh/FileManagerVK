//
//  HomeTableViewCell.swift
//  FileManagerVK
//
//  Created by Станислав on 23.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class FileTableViewCell: UITableViewCell {
    
    static let reusedID = "FileTableViewCell"
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()
    
    weak var delegate: HomeTableViewCellDelegate?
    var index: Int?
    
    let imageFile: UIImageView = {
        let imageFile = UIImageView()
        imageFile.translatesAutoresizingMaskIntoConstraints = false
        imageFile.layer.cornerRadius = 5
        imageFile.clipsToBounds = true
        return imageFile
    }()
    let titleFileLabel: UILabel = {
        let titleFile = UILabel()
        titleFile.translatesAutoresizingMaskIntoConstraints = false
        titleFile.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleFile.lineBreakMode = .byTruncatingMiddle
        titleFile.font = .boldSystemFont(ofSize: 20)
        return titleFile
    }()
    let dateFileLabel: UILabel = {
        let dateFile = UILabel()
        dateFile.translatesAutoresizingMaskIntoConstraints = false
        dateFile.font = .systemFont(ofSize: 14)
        dateFile.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        return dateFile
    }()
    let loadButton: UIButton = {
        let loadButton = UIButton()
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        loadButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return loadButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: FileTableViewCell.reusedID)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectionStyle = .none
        isUserInteractionEnabled = true
        
        addSubview(imageFile)
        addSubview(titleFileLabel)
        addSubview(dateFileLabel)
        addSubview(loadButton)
        
        NSLayoutConstraint.activate([
            
            imageFile.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageFile.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            imageFile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageFile.widthAnchor.constraint(equalToConstant: 40),
            imageFile.heightAnchor.constraint(equalToConstant: 40),
            
            titleFileLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleFileLabel.leadingAnchor.constraint(equalTo: imageFile.trailingAnchor, constant: 20),
            titleFileLabel.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor, constant: -20),
            
            dateFileLabel.topAnchor.constraint(equalTo: titleFileLabel.bottomAnchor, constant: 4),
            dateFileLabel.leadingAnchor.constraint(equalTo: imageFile.trailingAnchor, constant: 20),
            dateFileLabel.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor, constant: -20),
            
            loadButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loadButton.widthAnchor.constraint(equalToConstant: 20),
            loadButton.heightAnchor.constraint(equalToConstant: 20),      
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(for file: FileModel){
        let date = Date(timeIntervalSince1970: file.date)
        let dateString = FileTableViewCell.dateFormatter.string(from: date)
        
        loadButton.addTarget(self, action: #selector(changeState), for: .touchDown)
        loadButton.addTarget(self, action: #selector(loadFile), for: .touchUpInside)
        
        
        self.imageFile.image = UIImage(named: "\(file.type.getIconName())")
        self.titleFileLabel.text = file.title
        self.dateFileLabel.text = dateString
        self.setImageLoadButton(for: file)
        
    }
    
    @objc func loadFile() {
        if let index = index {
            delegate?.loadFile(indexCell: index)
        } else {
            print("File  не доступен")
        }
    }
    @objc func changeState(){
        UIView.animate(withDuration: 0.4, animations: {
            self.loadButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.loadButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }) { _ in
            self.loadButton.transform = .identity
        }
    }
    func setImageLoadButton(for file: FileModel){
        DispatchQueue.main.async {
            switch file.state {
            case .inCloud:
                if #available(iOS 13.0, *) {
                    self.loadButton.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
                } else {
                    self.loadButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.loadButton.layer.cornerRadius = 10
                    self.loadButton.layer.masksToBounds = true
                    // Fallback on earlier versions
                }
            case .loading:
                self.loadButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                UIView.transition(
                    with: self.loadButton,
                    duration: 0.6,
                    options: [.repeat, .transitionFlipFromLeft],
                    animations: nil,
                    completion: nil)
            case .loaded:
                self.loadButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.loadButton.layer.removeAllAnimations()
                if #available(iOS 13.0, *) {
                    self.loadButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                } else {
                    self.loadButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.loadButton.layer.cornerRadius = 10
                    self.loadButton.layer.masksToBounds = true
                    // Fallback on earlier versions
                }
            default:
                if #available(iOS 13.0, *) {
                    self.loadButton.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
                } else {
                    self.loadButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    self.loadButton.layer.cornerRadius = 10
                    self.loadButton.layer.masksToBounds = true
                    // Fallback on earlier versions
                }
            }
        }
    }
}
protocol HomeTableViewCellDelegate: class {
    func loadFile(indexCell: Int)
}
