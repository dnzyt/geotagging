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
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessController.cellId, for: indexPath) as! BusinessCell
        if indexPath.row == 0 {
            cell.questionLbl.text = "1. Activities in Nutrition Club; activities to support customer program in Nutrition Club"
            cell.ansLbl.text = "a. Weight Loss Challenge\nb. Masterclass– Healthy Snacking\nc. Healthy Active Lifestyle\nd. Skin Party\ne. Tea/Shake Party\nf. Others"
            cell.commentLbl.text = "You can add as much as you want to the comment Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The firs"
        } else if indexPath.row == 1 {
            cell.questionLbl.text = "2. Product sampling consumption; detail product consumes for customer program"
            cell.ansLbl.text = "a. Shake\nb. Aloe\nc. PPP\nd. Tea Series\ne. Others"
            cell.commentLbl.text = "You can add comment here to the questions and answers you provided"
        } else if indexPath.row == 2 {
            cell.questionLbl.text = "3. Open for Internship for New NC Owner; NC Owner open internship to all Member who interested to open a Nutrition Club"
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 3 {
            cell.questionLbl.text = "4. Daily Talking Point; NC Owner share talking point to upgrade nutrition information to all customer"
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 4 {
            cell.questionLbl.text = "5. Meal Plan; NC Owner give Meal Plan on customer program"
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 5 {
            cell.questionLbl.text = "6. Loyalty Program; NC Owner use loyalty program for their Customer"
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 6 {
            cell.questionLbl.text = "7. Use Customer Support tools "
            cell.ansLbl.text = "a. Gauges Application/nb. QRCode"
            cell.commentLbl.text = ""
        } else if indexPath.row == 7 {
            cell.questionLbl.text = "8. Social Media for support NC "
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 8 {
            cell.questionLbl.text = "9. Use Bizzworks for Support business Tools "
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 9 {
            cell.questionLbl.text = "10. Operation Hours "
            cell.ansLbl.text = "a. Morning\nb. Evening"
            cell.commentLbl.text = ""
        } else if indexPath.row == 10 {
            cell.questionLbl.text = "11. Membership Package"
            cell.ansLbl.text = "a. 10 Days\nb. 21 Days\nc. 30 Days"
            cell.commentLbl.text = ""
        } else if indexPath.row == 11 {
            cell.questionLbl.text = "12. Membership Fee for 10 days : IDR xxx "
            cell.ansLbl.text = ""
            cell.commentLbl.text = "IDR 251"
        } else if indexPath.row == 12 {
            cell.questionLbl.text = "13. Using Slim Marathon "
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 13 {
            cell.questionLbl.text = "14. Serving Take Away and Delivery"
            cell.ansLbl.text = "Yes"
            cell.commentLbl.text = ""
        } else if indexPath.row == 14 {
            cell.questionLbl.text = "15. Facility in Nutrition Club "
            cell.ansLbl.text = "a. Consumption\nb. Healthy Active Lifestyle"
            cell.commentLbl.text = ""
        }
        
        return cell
    }
    
    
}

extension BusinessController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qc = QuestionController()
        qc.modalPresentationStyle = .formSheet
        qc.completionHandler = {
            print("self....\(self.tv)")
            // refresh the table
        }
        present(qc, animated: true, completion: nil)
    }
}
