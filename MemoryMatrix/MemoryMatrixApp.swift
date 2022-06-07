//
//  MemoryMatrixApp.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinski on 6/6/22.
//

import Foundation

enum Level: String {
	case Easy, Medium, Hard
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
	private var gameIconSet = "Smiley"
	private var gameLevel = Level.Easy
	private var gameEnableSound = true
	private var gameClearMatchedPairs = true
	
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
	
	static func itemsFor(gameLevel: Level) -> Int {
		let len = gameLevel == .Easy ? 4 : gameLevel == .Medium ? 6 : 8
		return (len * len) / 2
	}
	
	private init() {
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
	}
}
