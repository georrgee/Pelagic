//  SwipingPhotosController.swift
//  Pelagic
//  Created by George Garcia on 8/11/19.
//  Copyright © 2019 GeeTeam. All rights reserved.

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedBar = UIColor(white: 0, alpha: 0.1)
    var controllers = [UIViewController]() // blank array

    var cardViewModel: CardViewModel! {
        didSet {
            print(cardViewModel.attributedText)
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            
            setupPhotoBarViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate   = self
    }
    
    
    fileprivate func setupPhotoBarViews() {
        
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBar
            barView.layer.cornerRadius = 2
            barsStackView.addSubview(barView)
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        view.addSubview(barsStackView)
        let paddingTop = UIApplication.shared.statusBarFrame.height + 8
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: { $0 == currentPhotoController }) {
            barsStackView.arrangedSubviews.forEach( { $0.backgroundColor = deselectedBar })
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index ==  0 {
            return nil
        }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count - 1 {
            return nil
        }
        return controllers[index + 1]
    }
}
