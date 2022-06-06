//
//  SelectIconsViewController.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinski on 6/6/22.
//

import UIKit

class SelectIconsTableCell: UITableViewCell {
	private var iconInfo: IconsSet?
	private var iconName = UILabel()
	private var iconImage = UIImageView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		iconImage.sizeToFit()
		iconImage.layer.borderWidth = 1
		iconImage.layer.borderColor = UIColor.lightGray.cgColor
		iconName.translatesAutoresizingMaskIntoConstraints = false
		iconImage.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(iconName)
		contentView.addSubview(iconImage)
		
		iconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
		iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
		iconImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
		iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor, multiplier: 1.0/1.0).isActive = true
		
		iconName.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 10).isActive = true
		iconName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
		iconName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
		iconName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setIconInfo(iconInfo: IconsSet) {
		self.iconInfo = iconInfo
		let iconPath = "\(iconInfo.path)/\(iconInfo.icons[0])"
		print(iconPath)
		if let image = UIImage(contentsOfFile: iconPath) {
			iconImage.image = image
		}
		iconName.text = iconInfo.name
	}
}

struct FolderInfo {
	var rootPath: String
	var name: String
	var icons: [String]
}
class IconsFolderTableCell: UITableViewCell {
	private var folderInfo: FolderInfo?
	private var folderName = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(folderName)

		folderName.translatesAutoresizingMaskIntoConstraints = false
		folderName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
		folderName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
		
		folderName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
	}
	
	func setFolderInfo(folderInfo: FolderInfo) {
		self.folderInfo = folderInfo
		folderName.text = folderInfo.name.replacingOccurrences(of: "_", with: " ")
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}

class SelectIconsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	var tableView = UITableView()
	var selected = ""
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		MemoryMatrixApp.shared.icons.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "icon-cell", for: indexPath) as? SelectIconsTableCell {
			//cell.textLabel?.text = "\(MemoryMatrixApp.shared.icons[indexPath.row].name)"
			cell.setIconInfo(iconInfo: MemoryMatrixApp.shared.icons[indexPath.row])
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selected = MemoryMatrixApp.shared.icons[indexPath.row].name
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .checkmark
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .none
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		
		tableView.register(SelectIconsTableCell.self, forCellReuseIdentifier: "icon-cell")
		tableView.delegate = self
		tableView.dataSource = self
    }

}
