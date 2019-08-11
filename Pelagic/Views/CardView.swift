//  CardView.swift
//  Pelagic
//  Created by George Garcia on 6/16/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    // encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "wife"))
    fileprivate let informationLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let threshold: CGFloat = 200
    
    fileprivate let barsStackView = UIStackView()
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageUrls.first ?? "" // 5)
            // 9) & 10)
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            
            informationLabel.attributedText = cardViewModel.attributedText
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = deselectedBarColor
                //barView.backgroundColor = .white
                barsStackView.addArrangedSubview(barView) // setup dummy bars
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (index, imageUrl) in // 8)
            
            if let url = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: url)
            }
            
            self?.barsStackView.arrangedSubviews.forEach({ (bars) in
                bars.backgroundColor = self?.deselectedBarColor
            })
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.white
        button.setImage(#imageLiteral(resourceName: "contact_details").withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupLayout() {
        // 3)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupBarsStackView()
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        // 4)
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    @objc fileprivate func handleMoreInfo() {
        // use a delegate
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
        // 11) 
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        
        let tapLocation = gesture.location(in: nil)
        let shouldGoToNextPhoto = tapLocation.x > (frame.width / 2) ? true : false
        
        if shouldGoToNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
        // 7)
    }
    // custom delcaration
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        // whenever the gesture is being tapped
        // switch = very large if statement
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subView) in
                subView.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
       // 6)
    }
    
    fileprivate func setupGradientLayer() {
        // 1)
        // 2)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1] // this corresponds to ^ (clear = 0.5, black = 1.1)
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)

        // rotation animation
        // by Converting radians to Degrees ( Formula: (degrees) x (pi/180) )
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }

    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
    
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                
                self.frame = CGRect(x: 1000 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
                
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            
            if shouldDismissCard {
                self.removeFromSuperview()
            }
//            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Notes

/*      1) Code removed. self.frame is actually the zero frame
        gradientLayer.frame = self.frame
 
        2) Code removed. We no longer need this
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
 
        3) Keep in mind. The order of your views are very important.
        i.e: if you put the function "setupGradientLayer" under information label. It will put the gradient layer on top of the "stack"
             meaning that, it will look pretty weird... (test it out to see)
 
        4) Code removed. We dont need that anymore
           informationLabel.text = "Test Name Test Age"
 
        5) using .first can guranteed that the app will never crash (if there are no photos; if imageNames.count == 0, it will crash)
 
        6) Code Removed: We are just setting up the dummy bars, now we are setting up a dynamic amount of bars the user has

                 (0..<4).forEach { (_) in
                 let barView = UIView()
                 barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                 //barView.backgroundColor = .white
                 barsStackView.addArrangedSubview(barView) // setup dummy bars
                 }
                 barsStackView.arrangedSubviews.first?.backgroundColor = .white
 
        7) Code Removed. We have a class function that can do the indexing for the user's photos
                 if nextPhoto {
                     imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
                 } else {
                     imageIndex = max(0, imageIndex - 1)
                 }
 
                 let imageName = cardViewModel.imageNames[imageIndex]
                 imageView.image = UIImage(named: imageName)
 
                 barsStackView.arrangedSubviews.forEach { (view) in
                     view.backgroundColor = deselectedBar
                 }
 
                 barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
 
        8) Note to self.
           - (Doesnt matter which you use) unowned/weak self = to avoid retain cycles; Every self must be optional.
 
        9) Code Removed. We are now going to load the image based on the URL
            //imageView.image = UIImage(named: imageName)
 
        10) Note: We have to load our image using some kind of url... That is where SDWebImage framework comes to the rescue!
 
        11) Code Removed. A Hack to present a view controller within a UIView Class. You DONT want any controller code inside a View Class
                     let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                     let userDetailsController = UIViewController()
                     userDetailsController.view.backgroundColor = .yellow
                     rootViewController?.present(userDetailsController, animated: true)
 */
