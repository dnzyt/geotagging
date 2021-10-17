//
//  BusinessController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class BusinessController: UIViewController {
    static let cellId = "businessCellId"
    
    var answers: [AnswerInfo]?
    
    let tv: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(BusinessCell.self, forCellReuseIdentifier: BusinessController.cellId)
        t.estimatedRowHeight = 300
        t.rowHeight = UITableView.automaticDimension
        t.separatorStyle = .none
        
        
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Business"
        
        setupTable()
        setupNavigationBar()

    }
    
    fileprivate func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .hbGreen
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let tv = UILabel()
        tv.text = "Nutrition Club"
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        
        navigationItem.titleView = tv
    }
    
    fileprivate func setupTable() {
        view.addSubview(tv)
        tv.delegate = self
        tv.dataSource = self
        
        tv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        NSLayoutConstraint.activate([
            tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tv.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tv.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }

}

extension BusinessController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessController.cellId, for: indexPath) as! BusinessCell
        let ans = answers![indexPath.row]
        cell.answer = ans

        
        return cell
    }
    
    
}

extension BusinessController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qc = QuestionController()
        qc.modalPresentationStyle = .formSheet
        qc.answer = answers![indexPath.row]
        qc.completionHandler = { [weak self] in
            self?.tv.reloadData()
        }
        present(qc, animated: true, completion: nil)
    }
}
