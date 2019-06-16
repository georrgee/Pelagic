//
//  TopNavigationStackView.swift
//  Pelagic
//
//  Created by George Garcia on 6/14/19.
//  Copyright © 2019 GeeTeam. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let settingsButton = UIButton(type: .system)
        let messageButton  = UIButton(type: .system)
        let wavesImageView = UIImageView(image: #imageLiteral(resourceName: "waves"))
        
        wavesImageView.contentMode = .scaleAspectFit
        
        settingsButton.setImage(#imageLiteral(resourceName: "profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "messages").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, UIView(), wavesImageView, UIView(), messageButton].forEach{ (views) in
            addArrangedSubview(views)
        }
        
        distribution = .equalCentering
        
        // Spacing/padding for the left and right corner buttons
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        // 1)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Notes

/*
 
 1)        CODE PREVIOUSLY
 
 //        let subViews = [#imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "waves"), #imageLiteral(resourceName: "messages")].map{ (image) -> UIView in
 //            let button = UIButton()
 //            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
 //            return button
 //        }
 //
 //        subViews.forEach{ (views) in
 //            addArrangedSubview(views)
 //        }
 
 */
