//
//  HomeTableView.swift
//  FileManagerVK
//
//  Created by Станислав on 22.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class HomeTableView: UITableView {
    let header = TableHeaderView(frame: .init(x: 0, y: 0, width: 0, height: 50))
    
    init(){
        super.init(frame: .zero, style: .grouped)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        separatorColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        //Cell
        register(FileTableViewCell.self, forCellReuseIdentifier: FileTableViewCell.reusedID)
        rowHeight = 56
        estimatedRowHeight = UITableView.automaticDimension
        translatesAutoresizingMaskIntoConstraints = false
        //Header
        tableHeaderView?.isHidden = false
        tableHeaderView = header
        tableHeaderView?.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

