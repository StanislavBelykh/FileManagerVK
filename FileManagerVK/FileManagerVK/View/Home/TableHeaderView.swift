//
//  TableHeaderControls.swift
//  FileManagerVK
//
//  Created by Станислав on 23.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    weak var delegate: TableHeaderControlsDelegate?
    
    let sortButton: UIButton = {
        let sortButton = UIButton()
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.setTitle("Сортировка по имени", for: .normal)
        sortButton.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        sortButton.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        sortButton.addTarget(self, action: #selector(selectSort), for: .touchUpInside)
        return sortButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            sortButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sortButton.widthAnchor.constraint(equalToConstant: 200)
            
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectSort(){
        delegate?.selectSort()
        
    }
}

protocol TableHeaderControlsDelegate: class  {
    func selectSort()
}
