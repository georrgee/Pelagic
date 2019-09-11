//  RegistrationModel.swift
//  Pelagic
//  Created by George Garcia on 6/27/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage         = Bindable<UIImage>()
    var bindableIsFormValid   = Bindable<Bool>()
    
    var fullName: String?  { didSet{ checkFormValidity() }}
    var email:    String?  { didSet{ checkFormValidity() }}
    var password: String?  { didSet{ checkFormValidity() }}
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (results, error) in // 2)
            if let err = error {
                completion(err)
                //self.showHUDWithError(error: err)
                return
            }
            self.uploadFileToStorage(completion: completion)
         // 1)
        print("User Registered!")
       }
    }
    
    fileprivate func uploadFileToStorage(completion: @escaping (Error?) -> ()) {
        
        let filename  = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        reference.putData(imageData, metadata: nil, completion: { (_, error) in
            if let error = error {
                completion(error)
                //                    self.showHUDWithError(error: error)
                return // if fails, must bail out of the code
            }
            print("Image uploaded to storage!")
            reference.downloadURL(completion: { (url, error) in
                if let err = error {
                    completion(err)
                    //self.showHUDWithError(error: err)
                }
                self.bindableIsRegistering.value = false // 4)
                print("Download url of our image is:", url?.absoluteString ?? "No URL")
                // storing the download url into Firestore
                let imageUrl = url?.absoluteString ?? "No Image Url"
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
                completion(nil)
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) { // 2)
        let user_id = Auth.auth().currentUser?.uid ?? "No ID"
        let docData = [
                       "fullName"      : fullName ?? "No Full Name",
                       "uid"           : user_id,
                       "imageUrl1"     : imageUrl,
                       "age"           : 18,
                       "minSeekingAge" : SettingsController.defaultMinSeekingAge,
                       "maxSeekingAge" : SettingsController.defaultMaxSeekingAge
            ] as [String : Any]
        
        Firestore.firestore().collection("users").document(user_id).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
    // Reactive programming
//    var isFormValidObserver: ((Bool)->())?
//    var imageObserver: ((UIImage?) -> ())?
}

// MARK: Notes

/*
    1) Code Refactored.
             let filename  = UUID().uuidString
             let reference = Storage.storage().reference(withPath: "/images/\(filename)")
             let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
 
             reference.putData(imageData, metadata: nil, completion: { (_, error) in
             if let error = error {
             completion(error)
             //                    self.showHUDWithError(error: error)
             return // if fails, must bail out of the code
             }
             print("Image uploaded to storage!")
             reference.downloadURL(completion: { (url, error) in
             if let err = error {
             completion(err)
             //self.showHUDWithError(error: err)
             }
             self.bindableIsRegistering.value = false // 4)
             print("Download url of our image is:", url?.absoluteString ?? "No URL")
             })
             })
             }
 
    2) Note: allows to save user info
 
 
 */
