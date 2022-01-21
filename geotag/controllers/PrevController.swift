//
//  PrevController.swift
//  geotag
//
//  Created by Ningze Dai on 1/12/22.
//

import UIKit

class PrevController: UIViewController {
    
    static let cellId = "prevCellId"
    
    var prevVisitInfo: PrevVisitInfo?
    
    let noPrevVisitPlate: UILabel = {
        let vl = UILabel()
        vl.translatesAutoresizingMaskIntoConstraints = false
        vl.text = "There is no previous visit information\n available for this club."
        vl.numberOfLines = 0
        vl.textAlignment = .center
        vl.textColor = .systemPink
        vl.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        return vl
    }()
    
    let tv: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(PrevCell.self, forCellReuseIdentifier: PrevController.cellId)
        t.estimatedRowHeight = 300
        t.rowHeight = UITableView.automaticDimension
        t.separatorStyle = .none
        
        
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Previous Visit Info"
        
        setupUI()
        setupNavigationBar()

    }
    
    fileprivate func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .hbGreen
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let tv = UILabel()
        tv.text = "Previous Visit Info"
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        
        navigationItem.titleView = tv
    }
    
    fileprivate func setupUI() {
        view.addSubview(noPrevVisitPlate)
        
        NSLayoutConstraint.activate([
            noPrevVisitPlate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            noPrevVisitPlate.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
        
        if prevVisitInfo?.prevAnswers?.count != 0 {
            view.addSubview(tv)
            
            tv.delegate = self
            tv.dataSource = self
            
            tv.backgroundColor = UIColor(white: 0.9, alpha: 1)
            
            NSLayoutConstraint.activate([
                tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tv.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tv.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
        }
        
        
    }

}


extension PrevController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prevVisitInfo?.prevAnswers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrevController.cellId, for: indexPath) as! PrevCell
        cell.answer = prevVisitInfo?.prevAnswers?[indexPath.row] as? PrevAnswer
        return cell
    }
    
    
}

extension PrevController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
