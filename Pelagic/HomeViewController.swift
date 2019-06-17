//  ViewController.swift
//  Pelagic
//  Created by George Garcia on 6/13/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class HomeViewController: UIViewController {
    
    let topStackView     = TopNavigationStackView()
    let buttonsStackView = HomeButtonControlsStackView()
    
    let cardsDeckView = UIView()
    
    let users = [
        User(name: "Ashley", age: 22, profession: "Adult Entertainer", imageName: "wife"),
        User(name: "Vicki", age: 26, profession: "Model", imageName: "vicki"),
        User(name: "Ana", age: 33, profession: "Entrepreneur", imageName: "ana"),
        User(name: "Shaida", age: 33, profession: "Professor", imageName: "shaida")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        
        users.forEach { (user) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: user.imageName)
            cardView.informationLabel.text = "\(user.name) \(user.age)\n\(user.profession)"
            
            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
            attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
            attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))

            cardView.informationLabel.attributedText = attributedText
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
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

