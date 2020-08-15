//
//  BaseViewController.swift
//  IOSDevJobs
//
//  Created by Станислав Белых on 19.07.2020.
//  Copyright © 2020 Станислав Белых. All rights reserved.
//

import UIKit

class BaseViewController<View: UIView>: UIViewController {
    
    typealias OnBackButtonTap = () -> Void
    
    var rootView: View { view as! View }
    var onBackButtonTap: OnBackButtonTap?
    
    override func loadView() {
        view = View()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            onBackButtonTap?()
        }
    }
    
}
