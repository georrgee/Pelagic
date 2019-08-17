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
    let imageUrls:     [String]
    let attributedText: NSAttributedString
    let textAlignment:  NSTextAlignment
    
    init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls     = imageNames
        self.attributedText = attributedText
        self.textAlignment  = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            //let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    var imageIndexObserver: ( (Int, String?) -> () )?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
        
        // Here we can apply reactive programming (expose a property on the View Model Objects)
    }
    
     func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}

// mark test 
