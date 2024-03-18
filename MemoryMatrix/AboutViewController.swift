//
//  GameAboutViewController.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinshi on 3/17/24.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        let aboutText = Bundle.main.object(forInfoDictionaryKey: "AboutText") as? String ?? "Some Hardcoded Stuff"
        label.text = aboutText
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
//        NSLayoutConstraint(
//            item: label,
//            attribute: .centerY,
//            relatedBy: .equal,
//            toItem: view,
//            attribute: .centerY,
//            multiplier: 0.7,
//            constant: 0
//        ).isActive = true
    }
    
}
