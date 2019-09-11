//  PhotoController.swift
//  Pelagic
//  Created by George Garcia on 9/11/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "vicki"))
    
    init(imageUrl: String) {        // creating an initializer that takes a URL
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
