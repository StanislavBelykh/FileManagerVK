//
//  DateFormatter.swift
//  FileManagerVK
//
//  Created by Полина on 17.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import Foundation

class DateFormatterApp {
    
    static let shared = DateFormatterApp()
    
    private init(){}
    
    private let fullDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter
    }()
    
    func getFullDate(_ inputDate: Double) -> String{
        let date = Date(timeIntervalSince1970: inputDate)
        return fullDateFormat.string(from: date)
    }
}

