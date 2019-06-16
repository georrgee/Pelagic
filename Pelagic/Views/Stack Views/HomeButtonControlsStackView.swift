//  HomeButtonControlsStackView.swift
//  Pelagic
//
//  Created by George Garcia on 6/14/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

// Main question: How do we use our home bottom control stackview to represent the 5 buttons instead of colors

import UIKit

class HomeButtonControlsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let subViews = [#imageLiteral(resourceName: "rewind"),#imageLiteral(resourceName: "pass"),#imageLiteral(resourceName: "super_life"),#imageLiteral(resourceName: "checkmark"),#imageLiteral(resourceName: "boost")].map { (image) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subViews.forEach{ (v) in
            addArrangedSubview(v)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
