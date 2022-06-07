//
//  GameBoardViewController.swift
//  AutoLayoutAndConstraints
//
//  Created by Rob Zmudzinski on 6/1/22.
//

import UIKit
import AVFoundation

class GameBoardViewController: UIViewController, AVAudioPlayerDelegate {
	var scoringEngine = ScoringEngine(gameLevel: .Easy)
	var iconImageViews = [UIImageView]()
	var iconImages = [UIImage]()
	var iconImageFiles = [String]()
	var gameBoard = UIView()
	var statusLabel = UILabel()
	var iconsSourcePath = ""
	var gameBoardItems = 0
	var firstSelectedImage: UIImageView? = nil
	var secondSelectedImage: UIImageView? = nil
	var matches = 0
	var misses = 0
	var sounds = [AVAudioPlayer]()
	var yahooSound: AVAudioPlayer? = nil
	
	func playSelectSound() async {
		if MemoryMatrixApp.shared.enableSound {
			var selectSound: AVAudioPlayer? = nil
			if let resourcePath = Bundle.main.resourcePath {
				let soundSourcePath = "\(resourcePath)/Sounds/success.wav"
				let url = URL(fileURLWithPath: soundSourcePath)
				selectSound = try? AVAudioPlayer(contentsOf: url)
			}
			if let success = selectSound {
				sounds.append(success)
				success.delegate = self
				success.volume = 0.4
				success.play()
			}
		}
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		print("Sounds: \(sounds.count)")
		if let playerIndex = sounds.firstIndex(where: { playerInstance in
			playerInstance == player
		}) {
			sounds.remove(at: playerIndex)
		}
		print("Sounds: \(sounds.count)")
	}
	
	func playYahoo() async {
		if MemoryMatrixApp.shared.enableSound {
			if let yahoo = yahooSound {
				yahoo.volume = 0.4
				yahoo.play()
			}
		}
	}
	
	convenience init(iconsSource: String) {
		self.init(nibName: nil, bundle: nil)
		let imagesSourcePath = "\(MemoryMatrixApp.shared.imageSourcePath)/\(MemoryMatrixApp.shared.iconSet)"
		iconsSourcePath = imagesSourcePath	//iconsSource
		scoringEngine = ScoringEngine(gameLevel: MemoryMatrixApp.shared.level)
		let requiredIcons = MemoryMatrixApp.iconsRequiredFor(gameLevel: MemoryMatrixApp.shared.level)
		gameBoardItems = Int(sqrt(Double(requiredIcons * 2)))	//MemoryMatrixApp.itemsFor(gameLevel: MemoryMatrixApp.shared.level) / 2
		loadImagesCache()
		if let resourcePath = Bundle.main.resourcePath {
			let soundSourcePath = "\(resourcePath)/Sounds/yahoo.wav"
			let url = URL(fileURLWithPath: soundSourcePath)
			yahooSound = try? AVAudioPlayer(contentsOf: url)
		}
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black
		gameBoard.backgroundColor = .black
		view.addSubview(gameBoard)
		view.addSubview(statusLabel)
		statusLabel.textColor = .white
		updateStatus()
		gameBoard.translatesAutoresizingMaskIntoConstraints = false
		statusLabel.translatesAutoresizingMaskIntoConstraints = false
		
		gameBoard.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		gameBoard.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
		
		gameBoard.heightAnchor.constraint(equalTo: gameBoard.widthAnchor).isActive = true
		gameBoard.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1).isActive = true
		gameBoard.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
		
		let widthConstraint = gameBoard.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
		widthConstraint.priority = UILayoutPriority(750)
		widthConstraint.isActive = true
		
		let heightConstraint = gameBoard.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
		heightConstraint.priority = UILayoutPriority(750)
		heightConstraint.isActive = true
		
		statusLabel.bottomAnchor.constraint(equalTo: gameBoard.topAnchor, constant: -40).isActive = true
		statusLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
		
		generateBoard(withNumberOfItems: gameBoardItems)
		assignIcons()
		
		navigationItem.rightBarButtonItems = []
	}
	
	func assignIcons() {
		//For each icon in the cache assign it to 2 random UIImageViews
		var boardItemIndexes: [Int] = Array(0..<iconImageViews.count)
		let iconIndexes: [Int] = Array(0..<iconImages.count)
		for index in iconIndexes {
			let firstIndex = Int.random(in: 0..<boardItemIndexes.count)
			let firstItemIndex = boardItemIndexes[firstIndex]
			boardItemIndexes.remove(at: firstIndex)
			iconImageViews[firstItemIndex].tag = index

			let secondIndex = Int.random(in: 0..<boardItemIndexes.count)
			let secondItemIndex = boardItemIndexes[secondIndex]
			boardItemIndexes.remove(at: secondIndex)
			iconImageViews[secondItemIndex].tag = index
		}
	}
	
	func loadImagesCache() {
		if let iconFiles = try? FileManager.default.contentsOfDirectory(atPath: iconsSourcePath) {
			let iconsRequired = (gameBoardItems * gameBoardItems)/2
			for iconFile in iconFiles {
				if iconImageFiles.count == iconsRequired {
					break
				}
				iconImageFiles.append(iconFile)
				let iconPath = "\(iconsSourcePath)/\(iconFile)"
				if let image = UIImage(contentsOfFile: iconPath) {
					iconImages.append(image)
				}
			}
		}
	}
	
	@objc func onIconTapped(sender: UITapGestureRecognizer) {

		if let iconImageView = sender.view as? UIImageView {
			let index = iconImageView.tag
			print("Image \(index) Tapped!!!")
			print(iconImageFiles[index])
			
			if firstSelectedImage == nil {
				firstSelectedImage = iconImageView
				iconImageView.image = iconImages[index]
				Task {
					await playSelectSound()
				}
				return
			} else {
				if secondSelectedImage == nil {
					secondSelectedImage = iconImageView
					iconImageView.image = iconImages[index]
					Task {
						await playSelectSound()
					}
				} else {
					//We are processing a potenial match
					return
				}
			}
			
			if let selectedImage = firstSelectedImage {
				if selectedImage.tag == iconImageView.tag {
					//Correct!
					print("Matched!!!")
					scoringEngine.onMatch()
					updateStatus()
					Task {
						await self.playYahoo()
					}
					if MemoryMatrixApp.shared.clearMatched {
						iconImageView.image = nil
						self.firstSelectedImage?.image = nil
					}
					self.firstSelectedImage = nil
					self.secondSelectedImage = nil
					matches += 1
					if scoringEngine.matched == self.gameBoardItems * 2 {
						onGameOver()
					}
				} else {
					//Not so much
					scoringEngine.onMismatch()
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
						if let self = self {
							self.misses += 1
							self.updateStatus()
							self.firstSelectedImage?.image = UIImage(named: "qm")
							iconImageView.image = UIImage(named: "qm")
							self.firstSelectedImage = nil
							self.secondSelectedImage = nil
						}
					}
					
				}
			}
		}
	}
	
	func onGameOver() {
		MemoryMatrixApp.shared.recordScore(score: scoringEngine.score) { recordHighScoreUser in
			let ac = UIAlertController(title: "Game Over", message: "Well done!", preferredStyle: .alert)
			ac.addTextField()
			ac.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
				if let textFields = ac.textFields, let user = textFields[0].text {
					recordHighScoreUser(user)
				}
			})
			present(ac, animated: true)
		} isNotHighScoreCallback: {
			let ac = UIAlertController(title: "Game Over", message: "Well done!", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Ok", style: .default))
			present(ac, animated: true)
		}
	}
	
	func updateStatus() {
		statusLabel.text = "\(scoringEngine.score) (\(scoringEngine.matched) of \(MemoryMatrixApp.iconsRequiredFor(gameLevel: MemoryMatrixApp.shared.level)))"
	}
	
	func generateBoard(withNumberOfItems items: Int) {
		//A valid board conforms to
		//Number of items % 2 == 0
		//That allows our game grid to be items x items...
//		guard items % 2 == 0 else {
//			return
//		}
		
		for item in 0..<items {
			print(item)//
			let row = item //< 2 ? item : items % item
			for column in 0..<items {
				let index = column + (row * items)
				
				if column == 0 {
					print("Start of row")
				}
				let topIndex = row > 0 ? index - items : 0
				print("row \(row) col \(column) item \(index) top \(topIndex)")
				let iconImageView = UIImageView(image: UIImage(named: "qm"))
				iconImageViews.append(iconImageView)
				iconImageView.tag = iconImageViews.count-1
				iconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onIconTapped)))
				iconImageView.isUserInteractionEnabled = true
				addBoardItem(boardSize: items, parentView: gameBoard, item: iconImageView, rightView: column == 0 ? nil : iconImageViews[iconImageViews.count-2], topView: row == 0 ? nil : iconImageViews[topIndex])
			}
		}
	}
	
	func addBoardItem(boardSize: Int, parentView: UIView, item: UIView, rightView: UIView?, topView: UIView?) {
		parentView.addSubview(item)
		item.translatesAutoresizingMaskIntoConstraints = false
		
		if let topView = topView {
			item.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
		} else {
			item.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
		}
		if let rightView = rightView {
			item.leadingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
		} else {
			item.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
		}
		
		_ = item.constraints.first(where: { _ in
			false
		})
		
		item.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 1.0/CGFloat(boardSize)).isActive = true
		item.heightAnchor.constraint(equalTo: item.widthAnchor).isActive = true
	}

}
