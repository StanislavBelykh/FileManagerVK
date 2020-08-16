//
//  FileListView.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class FileListViewImpl: UITableView {
    let header = TableHeaderView(frame: .init(x: 0, y: 0, width: 0, height: 50))
    
    init(){
        super.init(frame: .zero, style: .grouped)
        backgroundColor = GeneralColor.backgroundColor.uiColor()
        separatorColor = GeneralColor.subtitleTaxtColor.uiColor()
        
        //Cell
        register(FileTableViewCell.self, forCellReuseIdentifier: FileTableViewCell.reusedID)
        rowHeight = 56
        estimatedRowHeight = UITableView.automaticDimension
        translatesAutoresizingMaskIntoConstraints = false
        //Header
        tableHeaderView?.isHidden = false
        tableHeaderView = header
        tableHeaderView?.backgroundColor = GeneralColor.backgroundElementColor.uiColor()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
