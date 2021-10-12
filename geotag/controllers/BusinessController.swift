//
//  BusinessController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class BusinessController: UIViewController {
    static let cellId = "businessCellId"
    
    let tv: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(BusinessCell.self, forCellReuseIdentifier: BusinessController.cellId)
        t.estimatedRowHeight = 300
        t.rowHeight = UITableView.automaticDimension
        
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        navigationItem.title = "Business"
        
        setupTable()
        setupNavigationBar()

    }
    
    fileprivate func setupNavigationBar() {

    }
    
    fileprivate func setupTable() {
        view.addSubview(tv)
        tv.delegate = self
        tv.dataSource = self
        
        tv.backgroundColor = .systemBlue
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessController.cellId, for: indexPath) as! BusinessCell
        if indexPath.row == 0 {
            cell.questionLbl.text = "1. Activities in Nutrition Club; activities to support customer program in Nutrition Club"
            cell.ansLbl.text = "a. Weight Loss Challenge\nb. Masterclass– Healthy Snacking\nc. Healthy Active Lifestyle\nd. Skin Party\ne. Tea/Shake Party\nf. Others"
            cell.commentLbl.text = "f Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The firs"
        } else {
            cell.questionLbl.text = "Lorem Ipsum is \nrvived not only five cent\nuries, but also the leap into electronic typesetting, remaini\nLorem Ipsum is \nrvived not only five cent\nuries, but also the leap into electronic typesetting, remaini\nLorem Ipsum is \nrvived not only five cent\nuries, but also the leap into electronic typesetting, remaini\nLorem Ipsum is \nrvived not only five cent\nuries, but also the leap into electronic typesetting, remaini\nLorem Ipsum is \nrvived not only five cent\nuries, but also the leap into electronic typesetting, remaini"
            cell.ansLbl.text = "Contrary to popular belief, Lorem Ipsum is \nnot simply random text."
            cell.commentLbl.text = "f Good and Evil) by Cicero, written in 45 BC.\n This book is a treat\nise on the theory of ethics, very popular during the Renaissance. The firs"
        }
        
        return cell
    }
    
    
}

extension BusinessController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qc = QuestionController()
        qc.modalPresentationStyle = .formSheet
        qc.preferredContentSize = CGSize(width: 50, height: 50)
        present(qc, animated: true, completion: nil)
    }
}
