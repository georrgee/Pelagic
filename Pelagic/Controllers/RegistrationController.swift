//  RegistrationController.swift
//  Pelagic
//  Created by George Garcia on 6/24/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class RegistrationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        setupLayout()
        setupNotificationsObserver()
        setupTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // UI Components
    let selectPhotoButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Select Photo", for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
       button.backgroundColor = .white
       button.setTitleColor(.black, for: .normal)
       button.heightAnchor.constraint(equalToConstant: 275).isActive = true
       button.layer.cornerRadius = 16
       return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Full Name"
        textField.backgroundColor = .white
        return textField
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        return button
    }()
    
    fileprivate func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        let topColor    = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismissKeyboard)))
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [selectPhotoButton, fullNameTextField, emailTextField, passwordTextField, registerButton])
    
    fileprivate func setupLayout() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupNotificationsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    @objc fileprivate func handleTapDismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height // 3)
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
}
