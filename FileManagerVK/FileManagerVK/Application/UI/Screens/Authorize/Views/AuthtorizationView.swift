//
//  AuthtorizationView.swift
//  FileManagerVK
//
//  Created by Полина on 13.08.2020.
//  Copyright © 2020 Станислав. All rights reserved.
//

import UIKit

final class AuthtorizationView: UIView {
    weak var delegate: AutorizationViewDelegate?
    //MARK: - UI
    private let logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "Logo")
        logoView.backgroundColor = .clear
        logoView.layer.cornerRadius = 8
        logoView.clipsToBounds = true
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = GeneralColor.textColor.uiColor()
        titleLabel.text = NSLocalizedString("AuthtorizationViewImpl.titleLabel", comment: "Toggle lable authorization screen")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.tintColor = GeneralColor.textColor.uiColor()
        loginButton.setTitle(NSLocalizedString("AuthtorizationViewImpl.loginButton", comment: "authorization button"), for: .normal)
        loginButton.setTitleColor(GeneralColor.textColor.uiColor(), for: .normal)
        loginButton.setTitleColor(GeneralColor.subtitleTaxtColor.uiColor(), for: .highlighted)
        loginButton.addTarget(self, action: #selector(moveToAuth), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchDown)
        loginButton.backgroundColor = GeneralColor.buttonColor.uiColor()
        loginButton.layer.cornerRadius = 4
        loginButton.clipsToBounds = true
        return loginButton
    }()
    
    //MARK: - LiveCycle
    init() {
        super.init(frame: .zero)
        backgroundColor = GeneralColor.backgroundColor.uiColor()
        
        addSubview(logoView)
        addSubview(titleLabel)
        addSubview(loginButton)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.heightAnchor.constraint(equalToConstant: 200),
            logoView.widthAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    //MARK: - Animation
    func animateTitleLabel() {
        
        UIView.transition(with: titleLabel,
                          duration: 2,
                          options: [.repeat, .autoreverse, .transitionFlipFromTop],
                          animations: {
                            self.titleLabel.text = NSLocalizedString("AuthtorizationViewImpl.titleLabel.toggle", comment: "Toggle lable authorization screen")
        }, completion: { _ in
            self.titleLabel.text = NSLocalizedString("AuthtorizationViewImpl.titleLabel", comment: "Toggle lable authorization screen")
        })
    }
}

    //MARK: - Private func
private extension AuthtorizationView {
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
}

protocol AutorizationViewDelegate: class {
    func moveToRegistrationWebView()
}
