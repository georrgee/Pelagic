//  RegistrationController.swift
//  Pelagic
//  Created by George Garcia on 6/24/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
    
    let registrationViewModel = RegistrationViewModel()
    let registeringHUD        = JGProgressHUD(style: .dark)
    
    // MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        setupLayout()
        setupNotificationsObserver()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 1)
    }
    
    // MARK: UI Components
    let selectPhotoButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Select Photo", for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
       button.backgroundColor = .white
       button.setTitleColor(.black, for: .normal)
       button.heightAnchor.constraint(equalToConstant: 275).isActive = true
       button.layer.cornerRadius = 16
        
       button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
       button.imageView?.contentMode = .scaleAspectFill
       button.clipsToBounds = true 
       return button
    }()
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let fullNameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Full Name"
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return textField
    }()
    
    let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return textField
    }()
    
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupRegistrationViewModelObserver() {
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1) : .lightGray
            self.registerButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (image) in
           self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Registering..."
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
    }
    
    //MARK: Private Methods
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismissKeyboard)))
    }
    
    fileprivate func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        let topColor    = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [selectPhotoButton, fullNameTextField, emailTextField, passwordTextField, registerButton])
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupNotificationsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text =  "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    // MARK: @Objc Private Methods
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismissKeyboard()
        registrationViewModel.performRegistration { [weak self] (err) in
            if let err = err {
                self?.showHUDWithError(error: err)
                return
            }
            print("Finished Registering our user")
        }
        // 3)
    }
    
    @objc fileprivate func handleKeyboardHide(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    @objc fileprivate func handleTapDismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height // 3)
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else if textField == passwordTextField {
            registrationViewModel.password = textField.text
        }
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let profileImage = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = profileImage
        //registrationViewModel.image = profileImage
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Notes
/*
 
    1) Code Commented Out. If we have this code in the viewDisappear method, the keyboard will not shift the view up and it will look clunky
    // NotificationCenter.default.removeObserver(self)
 
    2) You can only upload images to Firebase Storage once you are authorized
 
    3) Code Removed. We don't want to use this in this function. Extra Code is uneccessary
         registeringHUD.textLabel.text = "Registering"
         registeringHUD.show(in: view)
 
    4) Dismisses the registering HUD
 
 */
