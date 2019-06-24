//  CardViewModel.swift
//  Pelagic
//  Created by George Garcia on 6/17/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    // define the properties that our view the display/render
    
    let imageNames:     [String]
    let attributedText: NSAttributedString
    let textAlignment:  NSTextAlignment
    
    init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames     = imageNames
        self.attributedText = attributedText
        self.textAlignment  = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    var imageIndexObserver: ( (Int, UIImage?) -> () )?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
        
        // Here we can apply reactive programming (expose a property on the View Model Objects)
    }
    
     func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
