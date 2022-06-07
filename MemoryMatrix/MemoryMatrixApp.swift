//
//  MemoryMatrixApp.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinski on 6/6/22.
//

import Foundation
import UIKit

enum Level: String {
	case Easy, Medium, Hard
}

struct HighScore: Codable {
	var name = ""
	var score = 0
}

class IconsSet {
	var name = ""
	var path = ""
	var icons = [String]()
	init(name: String, path: String, icons: [String]) {
		self.name = name
		self.path = path
		self.icons = icons
	}
}

class MemoryMatrixApp {
	static let shared = MemoryMatrixApp()
	public private(set) var icons = [IconsSet]()
	private var gameHighScores = [HighScore]()
	private var gameIconSet = "Smiley"
	private var gameLevel = Level.Easy
	private var gameEnableSound = true
	private var gameClearMatchedPairs = true
	private let maxNumberOfHighScore: Int
	
	var highScores: [HighScore] {
		get {
			gameHighScores.sorted { (hs1, hs2) in
				hs2.score < hs1.score
			}
		}
	}
	var imageSourcePath: String {
		get {
			if let resourcePath = Bundle.main.resourcePath {
				return "\(resourcePath)/GameIcons/Icons"
			}
			return ""
		}
	}
	
	var iconSet: String {
		get {
			gameIconSet
		}
		set {
			gameIconSet = newValue
			UserDefaults.standard.set(gameIconSet, forKey: "icons")
		}
	}
	
	var enableSound: Bool {
		get {
			return gameEnableSound
		}
		set {
			gameEnableSound = newValue
			UserDefaults.standard.set(gameEnableSound, forKey: "enableSound")
		}
	}
	
	var clearMatched: Bool {
		get {
			return gameClearMatchedPairs
		}
		set {
			gameClearMatchedPairs = newValue
			UserDefaults.standard.set(gameClearMatchedPairs, forKey: "clearMatched")
		}
	}
	
	var level: Level {
		get {
			gameLevel
		}
		set {
			gameLevel = newValue
			UserDefaults.standard.set(gameLevel.rawValue, forKey: "level")
		}
	}
	
	func recordScore(score: Int, isHighScoreCallback: (@escaping (String) -> Void) -> Void, isNotHighScoreCallback: () -> Void) {
		
		let recordHighScoreUser: (String) -> Void = { [weak self] user in
			if let self = self {
				if self.gameHighScores.count > 0 && self.gameHighScores.count >= self.maxNumberOfHighScore  {
					//Remove the item at the first index of our high scores (they are maintained in a sorted order
					self.gameHighScores.remove(at: 0)
				}
				//Record the high score, store, and then sort the high scores
				self.gameHighScores.append(HighScore(name: user, score: score))
				let encoder = JSONEncoder()
				if let data = try? encoder.encode(self.gameHighScores) {
					UserDefaults.standard.set(data, forKey: "HighScores")
				}
				self.gameHighScores.sort { (hs1, hs2) in
					hs1.score < hs2.score
				}
			}
		}
		
		if maxNumberOfHighScore > gameHighScores.count || gameHighScores.first(where: { highScore in score > highScore.score }) != nil {
			//It's a new high score
			isHighScoreCallback(recordHighScoreUser)
		} else {
			isNotHighScoreCallback()
		}
	}
	
	static func iconsRequiredFor(gameLevel level: Level) -> Int {
		let len = level == .Easy ? 4 : level == .Medium ? 6 : 8
		return (len * len) / 2
	}
	
	private init() {
		maxNumberOfHighScore = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
		let iconsPath = imageSourcePath
		let fileManager = FileManager()
		if let iconsList = try? fileManager.contentsOfDirectory(atPath: iconsPath) {
			for iconSet in iconsList {
				print(iconSet)
				let iconsSetPath = "\(iconsPath)/\(iconSet)"
				if let iconSetIcons = try? fileManager.contentsOfDirectory(atPath: iconsSetPath) {
					icons.append(IconsSet(name: iconSet, path: iconsSetPath, icons: iconSetIcons))
				}
			}
		}
		gameIconSet = UserDefaults.standard.string(forKey: "icons") ?? gameIconSet
		if let savedLevel = Level(rawValue: UserDefaults.standard.string(forKey: "level") ?? "") {
			gameLevel = savedLevel
			gameClearMatchedPairs = UserDefaults.standard.bool(forKey: "clearMatched")
			enableSound = UserDefaults.standard.bool(forKey: "enableSound")
			
		} else {
			//Nothing has been saved yet... force a save of the defaults
			iconSet = gameIconSet
			level = gameLevel
			clearMatched = gameClearMatchedPairs
			enableSound = gameClearMatchedPairs
		}
		
//		for score in 0..<5 {
//			gameHighScores.append(HighScore(name: "Score \(score)", score: Int.random(in: 0...500)))
//			print("Added score of \(gameHighScores[gameHighScores.count-1])")
//		}
//
//		let encoder = JSONEncoder()
//		if let data = try? encoder.encode(gameHighScores) {
//			UserDefaults.standard.set(data, forKey: "HighScores")
//		}
		
		let decoder = JSONDecoder()
		if let data = UserDefaults.standard.data(forKey: "HighScores") {
			if let highScores = try? decoder.decode([HighScore].self, from: data) {
				self.gameHighScores = highScores.sorted { (hs1, hs2) in
					hs1.score < hs2.score
				}
			}
		}
		
		print("High Scores\n============")
		for score in gameHighScores {
			print("Score: \(score.score)")
		}
		print("==================")
	}
}
