//  HomeButtonControlsStackView.swift
//  Pelagic
//  Created by George Garcia on 6/14/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

// Main question: How do we use our home bottom control stackview to represent the 5 buttons instead of colors

import UIKit

class HomeButtonControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton   = createButton(image: #imageLiteral(resourceName: "rewind"))
    let denyButton      = createButton(image: #imageLiteral(resourceName: "pass"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_life"))
    let likeButton      = createButton(image: #imageLiteral(resourceName: "checkmark"))
    let buzzButton      = createButton(image: #imageLiteral(resourceName: "boost"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        // 1)
        [refreshButton, denyButton, superLikeButton, likeButton, buzzButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Notes

/*
 
    1) Code Removed. We do not need to use this code anymore since we have a function that builds the buttons already
 
         let subViews = [#imageLiteral(resourceName: "rewind"),#imageLiteral(resourceName: "pass"),#imageLiteral(resourceName: "super_life"),#imageLiteral(resourceName: "checkmark"),#imageLiteral(resourceName: "boost")].map { (image) -> UIView in
             let button = UIButton(type: .system)
             button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
             return button
         }
 
         subViews.forEach{ (v) in
             addArrangedSubview(v)
         }

 
 */
