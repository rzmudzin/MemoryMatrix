//
//  HighScoresViewController.swift
//  AutoLayoutAndConstraints
//
//  Created by Rob Zmudzinski on 6/4/22.
//

import UIKit

class HighScoresViewController: UIViewController {
	var topHeaderImage = UIImageView()
	lazy var highScores: [UILabel] = {
		if UIDevice.current.userInterfaceIdiom == .pad {
			return [UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
		}
		return [UILabel(), UILabel(), UILabel()]
	}()
	var viewConstraints = [NSLayoutConstraint]()
	var portraitConstraints = [NSLayoutConstraint]()
	var landscapeConstraints = [NSLayoutConstraint]()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black

		view.addSubview(topHeaderImage)
		topHeaderImage.translatesAutoresizingMaskIntoConstraints = false
		topHeaderImage.image = UIImage(named: "trophy")
		
		let gameHighScores = MemoryMatrixApp.shared.highScores
		for index in 0..<highScores.count {
			let label = highScores[index]
			view.addSubview(label)
			label.translatesAutoresizingMaskIntoConstraints = false
			label.textColor = .white
			label.font = label.font.withSize(20)
			if gameHighScores.count > index {
				let gameScore = gameHighScores[index]
				label.text = "\(gameScore.score)\t\t\(gameScore.name)"
			}
		}

		createConstraints()
	}
	
	override func viewWillLayoutSubviews() {
		
		applyConstraints()
		
		for index in 0..<highScores.count {
			let label = highScores[index]
			if UIScreen.main.bounds.size.height < 500 {
				label.font = label.font.withSize(15)
			} else {
				label.font = label.font.withSize(20)
			}
		}
	}
	
	func applyConstraints() {
		for constraint in viewConstraints {
			constraint.isActive = true
		}
		if let orientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation {
			if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
				for constraint in portraitConstraints {
					constraint.isActive = false
				}
				for constraint in landscapeConstraints {
					constraint.isActive = true
				}
				
			} else if orientation == UIInterfaceOrientation.portrait || orientation == UIInterfaceOrientation.portraitUpsideDown {
				for constraint in portraitConstraints {
					constraint.isActive = true
				}
				for constraint in landscapeConstraints {
					constraint.isActive = false
				}
			}
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
		var previousScore: UILabel? = nil
		for index in 0..<highScores.count {
			let label = highScores[index]

			if let previousScore = previousScore {
				viewConstraints.append(label.topAnchor.constraint(equalTo: previousScore.bottomAnchor, constant: verticalSpacing))
				viewConstraints.append(label.leadingAnchor.constraint(equalTo: previousScore.leadingAnchor, constant: 0))
			} else {
				viewConstraints.append(label.topAnchor.constraint(equalTo: topHeaderImage.bottomAnchor, constant: 70))
				viewConstraints.append(label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0))
			}
			
			previousScore = label
		}
		
	}
}
