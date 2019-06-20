//  CardView.swift
//  Pelagic
//  Created by George Garcia on 6/16/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageName)
            informationLabel.attributedText = cardViewModel.attributedText
            informationLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    // encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "wife"))
    fileprivate let informationLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()

    fileprivate let threshold: CGFloat = 200
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    fileprivate func setupLayout() {
        // 3)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        // 4)
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.numberOfLines = 0
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
 */
