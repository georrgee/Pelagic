//  Firebase+Utilities.swift
//  Pelagic
//  Created by George Garcia on 7/22/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import Foundation
import Firebase

extension Firestore {
    
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapShot, error) in
            print("Extension. Got uid!: \(uid)")
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard let dictionary = snapShot?.data() else {
                let error = NSError(domain: "com.GeeTeam.Pelagic", code: 500, userInfo: [NSLocalizedDescriptionKey: "User Not Found in FireStore"])
                completion(nil, error)
                return
            }
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
        
    }
    
}
