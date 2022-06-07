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
		iconName.font = iconName.font.withSize(25)
		
		iconName.translatesAutoresizingMaskIntoConstraints = false
		iconImage.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(iconName)
		contentView.addSubview(iconImage)
		
		iconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
		iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
		iconImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
		iconImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
		iconImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
		
		iconName.centerYAnchor.constraint(equalTo: iconImage.centerYAnchor).isActive = true
		iconName.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 50).isActive = true
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setIconInfo(iconInfo: IconsSet) {
		self.iconInfo = iconInfo
		let iconPath = "\(iconInfo.path)/\(iconInfo.icons[1])"
		print(iconPath)
		if let image = UIImage(contentsOfFile: iconPath) {
			iconImage.image = image
		}
		iconName.text = iconInfo.name
	}
}

class SelectIconsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	var tableView = UITableView()
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		MemoryMatrixApp.shared.icons.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "icon-cell", for: indexPath) as? SelectIconsTableCell {
			let selectedIconSet = MemoryMatrixApp.shared.icons[indexPath.row]
			cell.setIconInfo(iconInfo: selectedIconSet)
			if selectedIconSet.name == MemoryMatrixApp.shared.iconSet {
				cell.accessoryType = .checkmark
			} else {
				cell.accessoryType = .none
			}
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		MemoryMatrixApp.shared.iconSet = MemoryMatrixApp.shared.icons[indexPath.row].name
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .checkmark
		}
		tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .none
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .black
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
