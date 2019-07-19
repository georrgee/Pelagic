//  AgeRangeCell.swift
//  Pelagic
//  Created by George Garcia on 7/19/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18 // minimum range of 18
        slider.maximumValue = 100
        return slider
        
    }()
    
    let maxSlider: UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
        
    }()
    
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min: 88"
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max: 88"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // draw a vertical stack views
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        ])
        
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AgeRangeLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        return .init(width: 80, height: 0)
    }
}
