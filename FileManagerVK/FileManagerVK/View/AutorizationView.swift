//
//  AutorizationView.swift
//  FileManagerVK
//
//  Created by Станислав on 17.04.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

class AutorizationView: UIView {
    
    weak var delegate: AutorizationViewDelegate?
    
    let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "Logo")
        logoView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        logoView.layer.cornerRadius = 8
        logoView.clipsToBounds = true
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.text = "File Manager VK"
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loginButton.setTitle("Авторизоваться", for: .normal)
        loginButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .highlighted)
        loginButton.addTarget(self, action: #selector(moveToAuth), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchDown)
        loginButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        loginButton.layer.cornerRadius = 4
        loginButton.clipsToBounds = true
        return loginButton
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        addSubview(logoView)
        addSubview(titleLabel)
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 200),
            logoView.widthAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func moveToAuth(){
        delegate?.moveToRegistrationWebView()
    }
    @objc func touchLoginButton() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .autoreverse, animations: {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.loginButton.transform = .identity
        })
    }
    func animateTitleLabel() {
        
        UIView.transition(with: titleLabel,
                          duration: 2,
                          options: [.repeat, .autoreverse, .transitionFlipFromTop],
                          animations: {
                            self.titleLabel.text = "Файловый менеджер"
        }, completion: { _ in
            self.titleLabel.text = "File Manager VK"
        })
    }
}

protocol AutorizationViewDelegate: class {
    func moveToRegistrationWebView()
}
