//  User.swift
//  Pelagic
//  Created by George Garcia on 6/17/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

struct User: ProducesCardViewModel {
    
    // Define the properties for a user
    let name:       String
    let age:        Int
    let profession: String
    let imageNames: [String]
    
    // Generate a new card view model
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        return CardViewModel(imageNames: imageNames, attributedText: attributedText, textAlignment: .left)
    }
    
}
