//
//  GameOptionsViewController.swift
//  AutoLayoutAndConstraints
//
//  Created by Rob Zmudzinski on 6/2/22.
//

import UIKit

class GameOptionsViewController: UIViewController {
	var topHeaderImage = UIImageView()
	var clearMatchedLabel = UILabel()
	var clearMatchedEnabledSwitch = UISwitch()
	var soundEnabledLabel = UILabel()
	var soundEnabledSwitch = UISwitch()
	var selectIconsButton = UIButton()
	var selectIconsLabel = UILabel()
	var selectGameLevel = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
	var selectGameLevelLabel = UILabel()
	let requiredIconsForEasy = MemoryMatrixApp.iconsRequiredFor(gameLevel: Level.Easy)
	let requiredIconsForMedium = MemoryMatrixApp.iconsRequiredFor(gameLevel: Level.Medium)
	let requiredIconsForHard = MemoryMatrixApp.iconsRequiredFor(gameLevel: Level.Hard)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .black

		view.addSubview(topHeaderImage)
		view.addSubview(clearMatchedLabel)
		view.addSubview(clearMatchedEnabledSwitch)
		view.addSubview(soundEnabledLabel)
		view.addSubview(soundEnabledSwitch)
		view.addSubview(selectIconsButton)
		view.addSubview(selectIconsLabel)
		view.addSubview(selectGameLevel)
		view.addSubview(selectGameLevelLabel)
		selectGameLevelLabel.translatesAutoresizingMaskIntoConstraints = false
		selectGameLevel.translatesAutoresizingMaskIntoConstraints = false
		selectIconsLabel.translatesAutoresizingMaskIntoConstraints = false
		selectIconsButton.translatesAutoresizingMaskIntoConstraints = false
		topHeaderImage.translatesAutoresizingMaskIntoConstraints = false
		clearMatchedLabel.translatesAutoresizingMaskIntoConstraints = false
		clearMatchedEnabledSwitch.translatesAutoresizingMaskIntoConstraints = false
		soundEnabledSwitch.translatesAutoresizingMaskIntoConstraints = false
		soundEnabledLabel.translatesAutoresizingMaskIntoConstraints = false
		
		selectGameLevelLabel.textColor = .white
		selectGameLevelLabel.text = "Difficulty Level"
		selectGameLevel.backgroundColor = .white
		
		let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
		let disabledTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
		selectGameLevel.setTitleTextAttributes(textAttributes, for: .normal)
		selectGameLevel.setTitleTextAttributes(disabledTextAttributes, for: .disabled)
		
		selectIconsLabel.textColor = .white
		selectIconsLabel.text = "Select Icons"
		selectIconsButton.setTitleColor(.white, for: .normal)
		selectIconsButton.setTitle(MemoryMatrixApp.shared.iconSet, for: .normal)
		clearMatchedLabel.textColor = .white
		clearMatchedLabel.text = "Clear Matched"
		soundEnabledLabel.textColor = .white
		soundEnabledLabel.text = "Sound Enabled"
		topHeaderImage.image = UIImage(named: "options")
		
		clearMatchedEnabledSwitch.isOn = MemoryMatrixApp.shared.clearMatched
		clearMatchedEnabledSwitch.addTarget(self, action: #selector(onClearMatchedChanged), for: .valueChanged)
		soundEnabledSwitch.isOn = MemoryMatrixApp.shared.enableSound
		soundEnabledSwitch.addTarget(self, action: #selector(onSoundEnabledChanged), for: .valueChanged)
		selectIconsButton.addTarget(self, action: #selector(onSelectIcon), for: .touchUpInside)
		for index in 00..<selectGameLevel.numberOfSegments {
			let segmentTitle = selectGameLevel.titleForSegment(at: index)
			if segmentTitle == MemoryMatrixApp.shared.level.rawValue {
				selectGameLevel.selectedSegmentIndex = index
				break;
			}
		}
		selectGameLevel.addTarget(self, action: #selector(onLevelChanged), for: .valueChanged)
		
		_ = applyConstraints()
		print("View Did Load Complete")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		selectIconsButton.setTitle(MemoryMatrixApp.shared.iconSet, for: .normal)
		validate()
	}
	
	@objc func onClearMatchedChanged() {
		MemoryMatrixApp.shared.clearMatched = clearMatchedEnabledSwitch.isOn
	}
	
	@objc func onSoundEnabledChanged() {
		MemoryMatrixApp.shared.enableSound = soundEnabledSwitch.isOn
	}
	
	func validate() {
		let requiredIcons = MemoryMatrixApp.iconsRequiredFor(gameLevel: MemoryMatrixApp.shared.level)
		if let iconSet = MemoryMatrixApp.shared.icons.first(where: { icons in
			icons.name == MemoryMatrixApp.shared.iconSet
		}) {
			if iconSet.icons.count <  requiredIcons {
				selectGameLevel.selectedSegmentIndex = 0
			}
			if iconSet.icons.count <  requiredIconsForHard {
				selectGameLevel.setEnabled(false, forSegmentAt: 2)
			} else {
				selectGameLevel.setEnabled(true, forSegmentAt: 2)
			}
			if iconSet.icons.count <  requiredIconsForMedium {
				selectGameLevel.setEnabled(false, forSegmentAt: 1)
			} else {
				selectGameLevel.setEnabled(true, forSegmentAt: 1)
			}
		}
	}
	
	@objc func onLevelChanged() {
		if let level = Level(rawValue: selectGameLevel.titleForSegment(at: selectGameLevel.selectedSegmentIndex) ?? "") {
			MemoryMatrixApp.shared.level = level
		}
	}
	
	@objc func onSelectIcon() {
		let selectIconsVC = SelectIconsViewController()
		navigationController?.pushViewController(selectIconsVC, animated: true)
	}
	
	func applyConstraints() -> [NSLayoutConstraint] {
		var viewConstraints = [NSLayoutConstraint]()
		let verticalSpacing = CGFloat(50)
		
		viewConstraints.append(NSLayoutConstraint(
			item: topHeaderImage,
			attribute: .centerY,
			relatedBy: .equal,
			toItem: view,
			attribute: .centerY,
			multiplier: 0.2,
			constant: 0
		))
		topHeaderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 20).isActive = true
		
		//Clear Matched Label
		NSLayoutConstraint(
			item: clearMatchedLabel,
			attribute: .centerX,
			relatedBy: .equal,
			toItem: view,
			attribute: .centerX,
			multiplier: 0.5,
			constant: 0
		).isActive = true
		clearMatchedLabel.topAnchor.constraint(equalTo: topHeaderImage.topAnchor, constant: 70).isActive = true
		
		//Clear Matched Switch
		NSLayoutConstraint(
			item: clearMatchedEnabledSwitch,
			attribute: .centerX,
			relatedBy: .equal,
			toItem: view,
			attribute: .centerX,
			multiplier: 1.5,
			constant: 0
		).isActive = true
		clearMatchedEnabledSwitch.centerYAnchor.constraint(equalTo: clearMatchedLabel.centerYAnchor).isActive = true
		
		//Sound Enabled Label
		soundEnabledLabel.leadingAnchor.constraint(equalTo: clearMatchedLabel.leadingAnchor, constant:0).isActive = true
		soundEnabledLabel.topAnchor.constraint(equalTo: clearMatchedLabel.topAnchor, constant:verticalSpacing).isActive = true
		
		//Sound Enabled Switch
		soundEnabledSwitch.trailingAnchor.constraint(equalTo: clearMatchedEnabledSwitch.trailingAnchor).isActive = true
		soundEnabledSwitch.centerYAnchor.constraint(equalTo: soundEnabledLabel.centerYAnchor).isActive = true

		//Select Icons Label
		selectIconsLabel.leadingAnchor.constraint(equalTo: soundEnabledLabel.leadingAnchor, constant:0).isActive = true
		selectIconsLabel.topAnchor.constraint(equalTo: soundEnabledLabel.topAnchor, constant: verticalSpacing).isActive = true
		
//		//Select Icons Button
		selectIconsButton.trailingAnchor.constraint(equalTo: soundEnabledSwitch.trailingAnchor).isActive = true
		selectIconsButton.centerYAnchor.constraint(equalTo: selectIconsLabel.centerYAnchor).isActive = true
	
		//Game Level Level
		selectGameLevelLabel.leadingAnchor.constraint(equalTo: selectIconsLabel.leadingAnchor, constant: 0).isActive = true
		selectGameLevelLabel.topAnchor.constraint(equalTo: selectIconsLabel.topAnchor, constant:verticalSpacing).isActive = true
		
		//Game Level
		if UIDevice.current.userInterfaceIdiom == .pad {
			selectGameLevel.trailingAnchor.constraint(equalTo: soundEnabledSwitch.trailingAnchor).isActive = true
			selectGameLevel.centerYAnchor.constraint(equalTo: selectGameLevelLabel.centerYAnchor).isActive = true
		} else {
			selectGameLevel.topAnchor.constraint(equalTo: selectGameLevelLabel.topAnchor, constant: 40).isActive = true
			selectGameLevel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
		}
		
		for constraint in viewConstraints {
			constraint.isActive = true
		}
		return viewConstraints
	}
	

}
