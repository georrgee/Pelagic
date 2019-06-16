//
//  ViewController.swift
//  Pelagic
//
//  Created by George Garcia on 6/13/19.
//  Copyright © 2019 GeeTeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView     = TopNavigationStackView()
    let buttonsStackView = HomeButtonControlsStackView()
    
    let blueView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blueView.backgroundColor = .blue
        setupLayout()
    }
    
    // MARK: - Fileprivate Methods
    
    fileprivate func setupLayout() {
        // 1)
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonsStackView])
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

/* MARK: Notes
 
 1) Removed
 //        buttonsStackView.distribution = .fillEqually
 //        buttonsStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
 
 */

