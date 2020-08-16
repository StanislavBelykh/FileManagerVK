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
        sortButton.setTitle(NSLocalizedString("TableHeaderView.sortButton.name", comment: "Button sort header table"), for: .normal)
        sortButton.setTitleColor(GeneralColor.activeTextColor.uiColor(), for: .normal)
        sortButton.tintColor = GeneralColor.activeTextColor.uiColor()
        sortButton.backgroundColor = .clear
        sortButton.addTarget(self, action: #selector(selectSort), for: .touchUpInside)
        return sortButton
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = GeneralColor.backgroundColor.uiColor()
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
    
    @objc private func selectSort(){
        delegate?.selectSort()
        
    }
}

protocol TableHeaderControlsDelegate: class  {
    func selectSort()
}
