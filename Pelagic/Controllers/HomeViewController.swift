//  ViewController.swift
//  Pelagic
//  Created by George Garcia on 6/13/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit
import Firebase
import JGProgressHUD

class HomeViewController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let topStackView     = TopNavigationStackView()
    let bottomControlsStackView = HomeButtonControlsStackView()
    let cardsDeckView = UIView()
    var cardViewModels = [CardViewModel]() // empty array
    fileprivate var user: User?
    let hud = JGProgressHUD(style: .dark)
    
    // 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControlsStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {  // check if user logs out
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navigationController = UINavigationController(rootViewController: registrationController)
            present(navigationController, animated: true)
        }
    }
    
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading..."
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch user:", error)
                self.hud.dismiss()
                return
            }
            self.user = user
            self.fetchUsersFromFireStore()
            self.hud.dismiss()
            print("fetchCurrentUser() from home controller got uid!: \(user?.uid ?? "NO ID From function in HomeViewController")")
        }
    }
    
    // MARK: @Objc Methods
    
    @objc fileprivate func handleRefresh() {
        self.fetchUsersFromFireStore()
    }
    
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsController()
        settingsController.settingsControllerDelegate = self
        let navigationController = UINavigationController(rootViewController: settingsController)
        present(navigationController, animated: true)
    }
    
    func didSaveSettings() {
        print("Settings Delegate Has Notified You That you are in Home Controller!!")
        fetchCurrentUser()
    }
    
    // MARK: Fileprivate Methods
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFireStore() { // when user presses the refresh button, this logic will fetch more users to populate
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Refreshing..."
        hud.show(in: view)
        
        guard let mininmumAge = user?.minSeekAge, let maximumAge = user?.maxSeekAge else { return }
        
        // 7)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: mininmumAge).whereField("age", isLessThanOrEqualTo: maximumAge)
        query.getDocuments { (snapShot, error) in
            hud.dismiss()
            if let err = error {
                print("Failed to fetch users:", err)
                return
            }
            
            snapShot?.documents.forEach({ (docSnapshot) in
                let userDictionary = docSnapshot.data()
                let user = User(dictionary: userDictionary)
                
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
                // 6)
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
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
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControlsStackView])
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        print("Home Controller:", cardViewModel.attributedText)
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
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
 
 7) Code removed. This is pagination. Refresh and fetches 2 users. Pagination will be implemented here (2 users at a time)

    .order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
 */

