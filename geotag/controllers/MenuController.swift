//
//  MenuController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

protocol MenuControllerDelegate: AnyObject {
    func menuTable(_ menuTable: UITableView, didSelectItemAt index: Int)
}

class MenuController: UIViewController {
    
    static let cellId = "menuCellId"
    
    weak var delegate: MenuControllerDelegate?
    
    let menuTable: UITableView = {
        let mt = UITableView()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.register(MenuCell.self, forCellReuseIdentifier: MenuController.cellId)
        mt.backgroundColor = .green
        
        return mt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMenuTable()
    }
    
    fileprivate func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .hbOrange
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let titleView = UILabel()
        titleView.textColor = .white
        titleView.text = "Menu"
        
        self.navigationItem.titleView = titleView
    }
    
    fileprivate func setupMenuTable() {
        view.addSubview(menuTable)
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        NSLayoutConstraint.activate([
            menuTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            menuTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }

}

extension MenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuController.cellId, for: indexPath)
        return cell
    }
    
    
}

extension MenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuTable(tableView, didSelectItemAt: indexPath.row)
    }
}
