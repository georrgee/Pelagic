//  SettingsController.swift
//  Pelagic
//  Created by George Garcia on 7/16/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Instance Properties (Indeed Accessible)
    lazy var imageButton1 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageButton2 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageButton3 = createButton(selector: #selector(handleSelectPhoto))
    var user: User?
    var settingsControllerDelegate: SettingsControllerDelegate?
    
    lazy var header: UIView = {
        let header = UIView()
        
        header.addSubview(imageButton1)
        let padding: CGFloat = 16
        imageButton1.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        imageButton1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let verticalStackView = UIStackView(arrangedSubviews: [imageButton2, imageButton3])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = padding
        
        header.addSubview(verticalStackView)
        verticalStackView.anchor(top: header.topAnchor, leading: imageButton1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView() // blank uiview that get rid of the horizontal lines
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
        
    }
    
    fileprivate func fetchCurrentUser() { // Fetching Firestore Data (fetching current user)
        
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch current user:", error)
                return
            }
            
            self.user = user
            self.loadUserPhotos()
            self.tableView.reloadData() // reload the data, you call the table view functions one more time
        }
    }
    
    fileprivate func loadUserPhotos() {
        
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton2.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton3.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return header
        }
        
        let headerLabel = HeaderLabel()
        
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1 // if the section is the first section(0), return the value of 0, otherwise return the value of 1
    }
    
    @objc fileprivate func handleMinRange(slider: UISlider) { // update the min label to its specific number
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        
        self.user?.minSeekAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxRange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        
        self.user?.maxSeekAge = Int(slider.value)

    }
    
    static let defaultMinSeekingAge = 18
    static let defaultMaxSeekingAge = 50
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinRange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxRange), for: .valueChanged)
            
            let minAge = user?.minSeekAge ?? SettingsController.defaultMinSeekingAge
            let maxAge = user?.maxSeekAge ?? SettingsController.defaultMaxSeekingAge
            
            // need to setup our labels on our cell here (if user cancels or saves or whatever, whenever they go back to the settings page, it should be stored)
            ageRangeCell.minLabel.text = "Min: \(minAge)"
            ageRangeCell.maxLabel.text = "Max: \(maxAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.maxSlider.value = Float(maxAge)
            return ageRangeCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.placeholder = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }
    
    @objc func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.originalImage] as? UIImage
        
        // how to set images for other buttons when photo selected button
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image..."
        hud.show(in: view)
        
        reference.putData(uploadData, metadata: nil) { (nil, error) in
            if let err = error {
                hud.dismiss()
                print("Failed to Upload Image to Storage!", err)
                return
            }
            print("Finished uploading image!")
            
            reference.downloadURL(completion: { (url, error) in
                
                hud.dismiss()
                if let err = error {
                    print("Failed to retrieve download url!", err)
                    return
                }
                print("Finished getting download url:", url?.absoluteString ?? "")
                
                if imageButton == self.imageButton1 {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.imageButton2 {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
          })
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true // let the image also be affected with the corner radius
        return button
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    @objc func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.imageButton = button
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        
        guard let user_id = Auth.auth().currentUser?.uid else { return }
        
        let docData: [String:Any] = [
            "uid"           : user_id,
            "fullName"      : user?.name ?? "",
            "imageUrl1"     : user?.imageUrl1 ?? "",
            "imageUrl2"     : user?.imageUrl2 ?? "",
            "imageUrl3"     : user?.imageUrl3 ?? "",
            "age"           : user?.age ?? -1,
            "profession"    : user?.profession ?? "",
            "minSeekingAge" : user?.minSeekAge ?? -1,
            "maxSeekingAge" : user?.maxSeekAge ?? -1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving..."
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(user_id).setData(docData) { (error) in
            hud.dismiss()
            if let err = error {
                print("Failed to save user info in settings",err)
                return
            }
            print("Finished saving user info")
            self.dismiss(animated: true, completion: {
                print("Dismissal complete")
                self.settingsControllerDelegate?.didSaveSettings()
            })
        }
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
}

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class HeaderLabel: UILabel {
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
