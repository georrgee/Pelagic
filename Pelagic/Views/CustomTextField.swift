//  CustomTextField.swift
//  Pelagic
//  Created by George Garcia on 6/24/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

// custom class for textfield; prefer method than using the anchors method
class CustomTextField: UITextField {
    
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect { // draw out the text inside the textField
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
