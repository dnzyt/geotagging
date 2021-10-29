//
//  MenuController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

protocol MenuControllerDelegate: AnyObject {
    func menuTable(_ menuTable: UITableView, didSelectItemAt index: Int)
    func hideMenu()
}

class MenuController: UIViewController {
    
    static let cellId = "menuCellId"
    
    weak var delegate: MenuControllerDelegate?
    
    let menuTable: UITableView = {
        let mt = UITableView()
        mt.translatesAutoresizingMaskIntoConstraints = false
        mt.register(MenuCell.self, forCellReuseIdentifier: MenuController.cellId)
        mt.backgroundColor = .white
        mt.estimatedRowHeight = 90
        mt.rowHeight = UITableView.automaticDimension
        
        return mt
    }()
    
    let hideBTN: UIButton = {
        let lbtn = UIButton()
        lbtn.setTitle("Hide Menu", for: .normal)
        lbtn.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        lbtn.translatesAutoresizingMaskIntoConstraints = false
        
        lbtn.addTarget(self, action: #selector(hideMenuAction), for: .touchUpInside)
        return lbtn
    } ()

    @objc private func hideMenuAction() {
        delegate?.hideMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        let indexPath = IndexPath(row: 0, section: 0)
        menuTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    fileprivate func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .hbGreen

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let titleView = UILabel()
        titleView.textColor = .white
        titleView.text = "Menu"
        
        self.navigationItem.titleView = titleView

    }
    
    fileprivate func setupUI() {
        view.addSubview(menuTable)
        view.addSubview(hideBTN)
        
        menuTable.delegate = self
        menuTable.dataSource = self
        
        NSLayoutConstraint.activate([
            menuTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuTable.bottomAnchor.constraint(equalTo: hideBTN.topAnchor),
            hideBTN.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hideBTN.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hideBTN.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }

}

extension MenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuController.cellId, for: indexPath) as! MenuCell
        if indexPath.row == 0 {
            cell.iconImageView.image = UIImage(systemName: "mail.stack")
            cell.mainLbl.text = "Business Method"
        } else if indexPath.row == 1 {
            cell.iconImageView.image = UIImage(systemName: "wallet.pass")
            cell.mainLbl.text = "Training System"
        } else if indexPath.row == 2 {
            cell.iconImageView.image = UIImage(systemName: "printer.dotmatrix")
            cell.mainLbl.text = "Tracking & Checklist"
        } else if indexPath.row == 3 {
            cell.iconImageView.image = UIImage(systemName: "suitcase")
            cell.mainLbl.text = "Feedback"
        }
        
        return cell
    }
    
    
}

extension MenuController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuTable(tableView, didSelectItemAt: indexPath.row)
    }
}
