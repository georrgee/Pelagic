//  CardViewModel.swift
//  Pelagic
//  Created by George Garcia on 6/17/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    // define the properties that our view the display/render
    
    let imageName:      String
    let attributedText: NSAttributedString
    let textAlignment:  NSTextAlignment
}
