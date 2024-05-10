//
//  GameAboutViewController.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinshi on 3/17/24.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    var topHeaderImage = UIImageView()
    var viewConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
//        Onboarding - Stay in the Know
        view.addSubview(topHeaderImage)
        topHeaderImage.translatesAutoresizingMaskIntoConstraints = false
        topHeaderImage.image = UIImage(named: "Onboarding - Stay in the Know")
        createConstraints()
    }
 
    override func viewWillLayoutSubviews() {
        applyConstraints()
    }
    func applyConstraints() {
        for constraint in viewConstraints {
            constraint.isActive = true
        }
    }
    func createConstraints() {
        let verticalSpacing = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 50 : 40)
        
        viewConstraints.append(NSLayoutConstraint(
            item: topHeaderImage,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 0.3,
            constant: 0
        ))
        viewConstraints.append(topHeaderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0))
    }
}
