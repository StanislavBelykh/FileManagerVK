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
    
    weak var delegate: HomeTableViewCellDelegate?
    var index: Int?
    
    private let imageFile: UIImageView = {
        let imageFile = UIImageView()
        imageFile.translatesAutoresizingMaskIntoConstraints = false
        imageFile.layer.cornerRadius = ConstreintConstant.cornerRadiusMidImage
        imageFile.clipsToBounds = true
        return imageFile
    }()
    
    private let titleFileLabel: UILabel = {
        let titleFile = UILabel()
        titleFile.translatesAutoresizingMaskIntoConstraints = false
        titleFile.textColor = GeneralColor.textColor.uiColor()
        titleFile.lineBreakMode = .byTruncatingMiddle
        titleFile.font = .boldSystemFont(ofSize: 20)
        return titleFile
    }()
    
    private let dateFileLabel: UILabel = {
        let dateFile = UILabel()
        dateFile.translatesAutoresizingMaskIntoConstraints = false
        dateFile.font = .systemFont(ofSize: 14)
        dateFile.textColor = GeneralColor.subtitleTaxtColor.uiColor()
        return dateFile
    }()
    
    private let loadButton: UIButton = {
        let loadButton = UIButton()
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.backgroundColor = .clear
        loadButton.tintColor = GeneralColor.buttonColor.uiColor()
        return loadButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: FileTableViewCell.reusedID)
        
        backgroundColor = GeneralColor.backgroundColor.uiColor()
        selectionStyle = .none
        isUserInteractionEnabled = true
        
        addSubview(imageFile)
        addSubview(titleFileLabel)
        addSubview(dateFileLabel)
        addSubview(loadButton)
        
        setConstreints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(for file: FileViewModel){
        self.imageFile.image = file.image
        self.titleFileLabel.text = file.title
        self.dateFileLabel.text = file.date
        self.setImageLoadButton(for: file.statusLoad)
        loadButton.addTarget(self, action: #selector(changeState), for: .touchDown)
        loadButton.addTarget(self, action: #selector(loadFile), for: .touchUpInside)
        
    }
    
    @objc private func loadFile() {
        if let index = index {
            delegate?.loadFile(indexCell: index)
        } else {
            print("File  не доступен")
        }
    }
    
    @objc private func changeState(){
        UIView.animate(withDuration: 0.4, animations: {
            self.loadButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.loadButton.tintColor = GeneralColor.buttonColor.uiColor()
        }) { _ in
            self.loadButton.transform = .identity
        }
    }
    
    private func setConstreints() {
        NSLayoutConstraint.activate([
            
            imageFile.topAnchor.constraint(equalTo: topAnchor, constant: ConstreintConstant.paddingMinimal),
            imageFile.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ConstreintConstant.paddingMinimal),
            imageFile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstreintConstant.padding),
            imageFile.widthAnchor.constraint(equalToConstant: ConstreintConstant.widthMidImage),
            imageFile.heightAnchor.constraint(equalToConstant: ConstreintConstant.heightMidImage),
            
            titleFileLabel.topAnchor.constraint(equalTo: topAnchor, constant: ConstreintConstant.paddingMinimal),
            titleFileLabel.leadingAnchor.constraint(equalTo: imageFile.trailingAnchor, constant: ConstreintConstant.padding),
            titleFileLabel.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor, constant: -ConstreintConstant.padding),
            
            dateFileLabel.topAnchor.constraint(equalTo: titleFileLabel.bottomAnchor, constant: ConstreintConstant.paddingMinimal),
            dateFileLabel.leadingAnchor.constraint(equalTo: imageFile.trailingAnchor, constant: ConstreintConstant.padding),
            dateFileLabel.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor, constant: -ConstreintConstant.padding),
            
            loadButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ConstreintConstant.padding),
            loadButton.widthAnchor.constraint(equalToConstant: ConstreintConstant.widthSmallButton),
            loadButton.heightAnchor.constraint(equalToConstant: ConstreintConstant.heightSmallButton),
        ])
    }
    
    func setImageLoadButton(for state: StateFile?){
        DispatchQueue.main.async {
            switch state {
            case .inCloud:
                if #available(iOS 13.0, *) {
                    self.loadButton.tintColor = GeneralColor.buttonColor.uiColor()
                    self.loadButton.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
                } else {
                    self.loadButton.backgroundColor = GeneralColor.buttonColor.uiColor()
                    self.loadButton.layer.cornerRadius = ConstreintConstant.cornerRadiusSmallButton
                    self.loadButton.layer.masksToBounds = true
                    // Fallback on earlier versions
                }
                
            case .loading:
                self.loadButton.tintColor = GeneralColor.buttonColor.uiColor()
                UIView.transition(
                    with: self.loadButton,
                    duration: 0.6,
                    options: [.repeat, .transitionFlipFromLeft],
                    animations: nil,
                    completion: nil)
                
            case .loaded:
                self.loadButton.tintColor = GeneralColor.activeTextColor.uiColor()
                self.loadButton.layer.removeAllAnimations()
                if #available(iOS 13.0, *) {
                    self.loadButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                } else {
                    self.loadButton.backgroundColor = GeneralColor.activeTextColor.uiColor()
                    self.loadButton.layer.cornerRadius = ConstreintConstant.cornerRadiusSmallButton
                    self.loadButton.layer.masksToBounds = true
                    // Fallback on earlier versions
                }
                
            default:
                if #available(iOS 13.0, *) {
                    self.loadButton.tintColor = GeneralColor.buttonColor.uiColor()
                    self.loadButton.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
                } else {
                    self.loadButton.backgroundColor = GeneralColor.buttonColor.uiColor()
                    self.loadButton.layer.cornerRadius = ConstreintConstant.cornerRadiusSmallButton
                    self.loadButton.layer.masksToBounds = true
                    // Fallback on earlier versions
                }
            }
        }
    }
}
protocol HomeTableViewCellDelegate: AnyObject {
    func loadFile(indexCell: Int)
}
