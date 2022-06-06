//
//  SelectIconsViewController.swift
//  MemoryMatrix
//
//  Created by Rob Zmudzinski on 6/6/22.
//

import UIKit

class SelectIconsTableCell: UITableViewCell {
	
}

class SelectIconsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	var tableView = UITableView()
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = "\(indexPath.row)"
		return cell
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		
		tableView.delegate = self
		tableView.dataSource = self
    }

}
