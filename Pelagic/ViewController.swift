//  ViewController.swift
//  Pelagic
//  Created by George Garcia on 6/13/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    let topStackView     = TopNavigationStackView()
    let buttonsStackView = HomeButtonControlsStackView()
    
    let cardsDeckView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        
        print("Setting up Dummy Cards")
        let cardView = CardView(frame: .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }

    
    // MARK: - Fileprivate Methods
    
    fileprivate func setupLayout() {
        // 1)
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}


/* MARK: Notes
 
 1) Removed
 //        buttonsStackView.distribution = .fillEqually
 //        buttonsStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
 
 */

