//
//  MemoryMatrixApp.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinski on 6/6/22.
//

import Foundation

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
	
	private init() {
		if let resourcePath = Bundle.main.resourcePath {
			let iconsPath = "\(resourcePath)/GameIcons/Icons"
			let fileManager = FileManager()
			if let iconsList = try? fileManager.contentsOfDirectory(atPath: iconsPath) {
				for iconSet in iconsList {
					print(iconSet)
					let iconsSetPath = "\(resourcePath)/GameIcons/Icons/\(iconSet)"
					if let iconSetIcons = try? fileManager.contentsOfDirectory(atPath: iconsSetPath) {
						icons.append(IconsSet(name: iconSet, path: iconsSetPath, icons: iconSetIcons))
					}
				}
			}
		}
	}
}
