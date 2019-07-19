//  User.swift
//  Pelagic
//  Created by George Garcia on 6/17/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

struct User: ProducesCardViewModel {
    
    // Define the properties for a user
    var name:       String?
    var age:        Int?
    var profession: String?
    var uid:        String?
    var imageUrl1:  String?
    var imageUrl2:  String?
    var imageUrl3:  String?
    var minSeekAge: Int?
    var maxSeekAge: Int?

    
    init(dictionary: [String: Any]) {
        self.age        = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name       = dictionary["fullName"] as? String ?? "Nothing"
        self.imageUrl1  = dictionary["imageUrl1"] as? String
        self.imageUrl2  = dictionary["imageUrl2"] as? String
        self.imageUrl3  = dictionary["imageUrl3"] as? String
        self.uid        = dictionary["uid"] as? String ?? ""
        self.minSeekAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekAge = dictionary["maxSeekingAge"] as? Int
    }
    
    // Generate a new card view model
    
    func toCardViewModel() -> CardViewModel {
        
        let ageString        = age != nil ? "\(age!)" : "N\\A"
        let professionString = profession != nil ? "\(profession!)" : "Not Avaliable"
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age ?? 0)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        var imageUrls = [String]()
        if let url    = imageUrl1 { imageUrls.append(url) }
        if let url    = imageUrl2 { imageUrls.append(url) }
        if let url    = imageUrl3 { imageUrls.append(url) }
        
        return CardViewModel(imageNames: imageUrls, attributedText: attributedText, textAlignment: .left)
    }
}

// MARK: Notes

/*  1) Code Removed.
    //self.imageNames = [imageUrl1]

 
 
 */
