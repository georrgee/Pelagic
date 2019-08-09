//  UserDetailsController.swift
//  Pelagic
//  Created by George Garcia on 8/2/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "vicki"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label  = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text below"
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(userImageView)
        userImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width) // why frame rather using auto layout (6:43)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: userImageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        userImageView.frame = CGRect(x: min(0,-changeY), y: min(0,-changeY), width: width, height: width) // views width is exapnding as you drag downwards
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
}
