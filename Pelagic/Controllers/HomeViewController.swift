//  ViewController.swift
//  Pelagic
//  Created by George Garcia on 6/13/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    let topStackView     = TopNavigationStackView()
    let buttonsStackView = HomeButtonControlsStackView()
    
    let cardsDeckView = UIView()
    // 5)
    var cardViewModels = [CardViewModel]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)

        setupLayout()
        //bsetupDummyCards()
        fetchUsersFromFireStore()
    }
    
    @objc func handleSettings() {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    // MARK: - Fileprivate Methods
    
    fileprivate func fetchUsersFromFireStore() {
        
//        let query = Firestore.firestore().collection("users").whereField("age", isLessThan: 31)
        
        Firestore.firestore().collection("users").getDocuments { (snapShot, error) in
            if let err = error {
                print("Failed to fetch users:", err)
                return
            }
            snapShot?.documents.forEach({ (docSnapshot) in
                let userDictionary = docSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                // 6)
            })
            self.setupFirestoreUserCards()
        }
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardViewVM) in
            
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewVM
            // 4)
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        } // 2)
    }
    
    fileprivate func setupLayout() {
        // 1)
        view.backgroundColor = .white
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
 
         buttonsStackView.distribution = .fillEqually
         buttonsStackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
 
 2) Removed - This code is placed into the CardViewModel.swift file. Reason: Better coding structure
 
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
 
 3) Removed Old Structure
             let cardViewModel = [
             User(name: "Vicki", age: 26, profession: "Model", imageName: "vicki").toCardViewModel(),
             User(name: "Ana", age: 33, profession: "Entrepreneur", imageName: "ana").toCardViewModel(),
             User(name: "Shaida", age: 33, profession: "Professor", imageName: "shaida").toCardViewModel(),
             User(name: "Ashley", age: 22, profession: "Adult Entertainer", imageName: "wife").toCardViewModel(),
             Advertiser(title: "Dos Flavors!", brandName: "Sour Patch", posterPhotoName: "gummy_bear_ad").toCardViewModel()
            ]
 
            We can defintely restructure to this ^
 
 4) Remove 3 lines of code - Better structure
             cardView.imageView.image = UIImage(named: cardViewVM.imageName)
             cardView.informationLabel.attributedText = cardViewVM.attributedText
             cardView.informationLabel.textAlignment = cardViewVM.textAlignment
 
 5) Code Removed. We do not need to use the dummy data anymore
 
     //    let cardViewModel: [CardViewModel] = { // 3)
     //        let producers = [
     //            User(name: "Vicki", age: 26, profession: "Model", imageNames: ["vicki", "vicki2", "vicki3", "vicki4"]),
     //            User(name: "Shaida", age: 33, profession: "Professor", imageNames: ["shaida"]),
     //            Advertiser(title: "Dos Flavors!", brandName: "Sour Patch", posterPhotoName: "gummy_bear_ad"),
     //            User(name: "Ana", age: 33, profession: "Entrepreneur", imageNames: ["ana", "ana2"]),
     //            User(name: "Ashley", age: 22, profession: "Adult Entertainer", imageNames: ["wife", "wife2", "wife3"])
     //        ] as [ProducesCardViewModel]
     //
     //        let viewModels = producers.map{$0.toCardViewModel() }
     //        return viewModels
     //    }()
 
 6) Code Removed.
    print(user.name, user.imageNames)
 */

