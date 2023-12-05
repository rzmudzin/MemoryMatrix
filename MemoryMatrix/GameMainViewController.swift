//
//  GameMainViewController.swift
//  AutoLayoutAndConstraints
//
//  Created by Rob Zmudzinski on 6/1/22.
//

import UIKit
import AVFoundation

class GameMainViewController: UIViewController {
	var startGameButton = UIButton();
	var highScoresButton = UIButton()
	var optionsButton = UIButton()
	var yahooSound: AVAudioPlayer? = nil
	
	func playYahoo() async {
		if MemoryMatrixApp.shared.enableSound {
			if let yahoo = yahooSound {
				yahoo.volume = 0.4
				yahoo.play()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let resourcePath = Bundle.main.resourcePath {
			let soundSourcePath = "\(resourcePath)/Sounds/yahoo.wav"
			let url = URL(fileURLWithPath: soundSourcePath)
			yahooSound = try? AVAudioPlayer(contentsOf: url)
		}
		
		view.backgroundColor = .black
		view.addSubview(startGameButton)
		view.addSubview(highScoresButton)
		view.addSubview(optionsButton)
		
		highScoresButton.setImage(UIImage(named: "HScores"), for: .normal)
		highScoresButton.addTarget(self, action: #selector(showHighScores), for: .touchUpInside)
		optionsButton.setImage(UIImage(named: "Options"), for: .normal)
		optionsButton.addTarget(self, action: #selector(showGameOptions), for: .touchUpInside)
		startGameButton.setImage(UIImage(named: "start"), for: .normal)
		startGameButton.addTarget(self, action: #selector(onStartGame), for: .touchUpInside)
		
		startGameButton.translatesAutoresizingMaskIntoConstraints = false
		highScoresButton.translatesAutoresizingMaskIntoConstraints = false
		optionsButton.translatesAutoresizingMaskIntoConstraints = false
		
		startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		NSLayoutConstraint(
			item: startGameButton,
			attribute: .centerY,
			relatedBy: .equal,
			toItem: view,
			attribute: .centerY,
			multiplier: 0.7,
			constant: 0
		).isActive = true
		
//		buttonConstraintsA()
//		buttonConstraintsB()
		buttonConstraintsC()
	}
	
	func buttonConstraintsA() {
		optionsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
		optionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		highScoresButton.bottomAnchor.constraint(equalTo: optionsButton.topAnchor, constant: -5).isActive = true
		highScoresButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	func buttonConstraintsB() {
		NSLayoutConstraint(
			item: highScoresButton,
			attribute: .top,
			relatedBy: .equal,
			toItem: startGameButton,
			attribute: .bottom,
			multiplier: 1.25,
			constant: 0
		).isActive = true
		highScoresButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
		optionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		optionsButton.topAnchor.constraint(equalTo: highScoresButton.bottomAnchor, constant: 5).isActive = true
	}
	
	func buttonConstraintsC() {
		NSLayoutConstraint(
			item: highScoresButton,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: startGameButton,
			attribute: .bottom,
			multiplier: 1.35,
			constant: 0
		).isActive = true
		highScoresButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
		optionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		optionsButton.topAnchor.constraint(equalTo: highScoresButton.bottomAnchor, constant: 20).isActive = true
	}

	
	@objc func showHighScores() {
		print("Show High Scores")
		let highScoresVC = HighScoresViewController()
		self.navigationController?.pushViewController(highScoresVC, animated: true)
	}
	@objc func showGameOptions() {
		print("Show Game Options")
		let gameOptionsVC = GameOptionsViewController()
		self.navigationController?.pushViewController(gameOptionsVC, animated: true)
	}
	@objc func onStartGame() {
		Task {
			await playYahoo()
		}
		if let resourcePath = Bundle.main.resourcePath {
			let iconsPath = "\(resourcePath)/GameIcons/Icons/Smiley"
			let gameBoardViewController = GameBoardViewController(iconsSource: iconsPath)
			navigationController?.pushViewController(gameBoardViewController, animated: true)
		}
	}
}
