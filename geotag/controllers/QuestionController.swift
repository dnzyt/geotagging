//
//  QuestionController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

//protocol QuestionControllerDelegate {
//    func answerFinished(_ result: Bool)
//}

class QuestionController: UIViewController {
    
    var answer: AnswerInfo? {
        didSet {
            if answer?.questionType == "MULTI_SELECT" {
                table.allowsMultipleSelection = true
            } else {
                table.allowsMultipleSelection = false
            }
            questionLbl.text = answer?.label
            if let commentContent = answer?.comment {
                commentView.text = commentContent
                commentView.textColor = .black
            }
            
            if let userEntry = answer?.textBox {
                userEntryTF.text = userEntry
            }
        }
    }
    var completionHandler: (() -> ())?
    
    static let cellId = "answerCellId"
    
    let table: UITableView = {
        let t = UITableView()
        t.backgroundColor = .white
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(AnswerCell.self, forCellReuseIdentifier: QuestionController.cellId)
        t.alwaysBounceVertical = false
        t.layer.cornerRadius = 10
        t.separatorStyle = .none
        t.allowsMultipleSelection = false
        t.layer.borderColor = UIColor.hbGreen.cgColor
        t.layer.borderWidth = 2
        

        return t
    }()
    
    let userEntryTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "IDR: (numbers only)"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .systemGray
        tf.borderStyle = .none
        return tf
    }()
    
    let questionLbl: UILabel = {
        let ql = UILabel()
        ql.numberOfLines = 0
        ql.font = UIFont(name: "GillSans-SemiBoldItalic", size: 14)
        ql.translatesAutoresizingMaskIntoConstraints = false
        ql.textColor = .hbGreen
        
        return ql
    }()
    
    let commentView: UITextView = {
        let c = UITextView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.textAlignment = .left
        c.textColor = .lightGray
        c.alwaysBounceVertical = false
        c.text = "Comment:"
        c.layer.borderColor = UIColor.hbGreen.cgColor
        c.layer.borderWidth = 2
        
        
        
        c.layer.cornerRadius = 10
        
        return c
    }()
    

    
    let okBtn: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        b.backgroundColor = .clear
        b.tintColor = .hbGreen
        return b
        
    }()
    
    deinit {
        print("deallocated...")
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        modalPresentationStyle = .formSheet
        preferredContentSize = CGSize(width: 500, height: 620)
        
        table.delegate = self
        table.dataSource = self
        userEntryTF.delegate = self
        commentView.delegate = self
        
        setupUI()
        if answer?.questionType == "USER_ENTRY" {
            userEntryTF.isHidden = false
            table.isHidden = true
            commentView.isHidden = true
        } else {
            userEntryTF.isHidden = true
            table.isHidden = false
            commentView.isHidden = false
        }
        
        okBtn.addTarget(self, action: #selector(okAction), for: .touchUpInside)

    }
    
    @objc func okAction() {
        if let rows = table.indexPathsForSelectedRows {
            answer?.ans?.removeAll()
            for r in rows {
                answer?.ans?.append(r.row)
            }
        }
        
        if commentView.textColor == .black {
            answer?.comment = commentView.text
        }
        
        answer?.textBox = userEntryTF.text
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        try? context.save()
        
        dismiss(animated: true, completion: nil)
        completionHandler!()

    }
    
    private func setupUI() {
        view.addSubview(questionLbl)
        view.addSubview(table)
        view.addSubview(userEntryTF)
        view.addSubview(commentView)
        view.addSubview(okBtn)
        
        NSLayoutConstraint.activate([
            questionLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            questionLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            questionLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            userEntryTF.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 30),
            userEntryTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            userEntryTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            table.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 30),
            table.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            table.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            commentView.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 30),
            commentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
            commentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
            commentView.heightAnchor.constraint(equalToConstant: 100),
            okBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            okBtn.heightAnchor.constraint(equalToConstant: 50),
            okBtn.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    override func viewDidLayoutSubviews() {
        let num = table.numberOfRows(inSection: 0)
        let cell = table.cellForRow(at: IndexPath(row: 0, section: 0))
        let height = cell!.frame.height * CGFloat(num)
        
        table.heightAnchor.constraint(equalToConstant:height > 300 ? 300 : height).isActive = true
        
        let circle = CAShapeLayer()
        circle.path = UIBezierPath(ovalIn: CGRect(x: -6, y: -6, width: okBtn.frame.width + 12, height: okBtn.frame.height + 12)).cgPath
        circle.strokeColor = UIColor.hbGreen.cgColor
        circle.fillColor = UIColor.clear.cgColor
        circle.lineWidth = 2
        
        okBtn.layer.addSublayer(circle)
        
        if let ans = answer?.ans {
            for i in ans {
                table.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
        

    }

}

extension QuestionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answer?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestionController.cellId, for: indexPath) as! AnswerCell
        let dropDownItem = answer?.items?.array[indexPath.row] as! DropDownItem
        cell.optionLbl.text = dropDownItem.labelValue


        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    
}

extension QuestionController: UITableViewDelegate {

}

extension QuestionController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldString = textField.text else { return false }

        let temp = oldString as NSString
        let newString = temp.replacingCharacters(in: range, with: string)
        
        let processedNewString = removeCommaFrom(newString)
        print("processed new string: \(processedNewString)")
        
        let decimalPattern = "^[0-9]*((\\.)[0-9]{0,2})?$"
        let decimalRegex = try! NSRegularExpression(pattern: decimalPattern, options: .caseInsensitive)
        let numOfMatches = decimalRegex.numberOfMatches(in: processedNewString, options: .anchored, range: NSRange(location: 0, length: processedNewString.count))
        if processedNewString.last == "." {
            return true
        }
        if numOfMatches != 0 {
            textField.text = addCommaTo(processedNewString).replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        }
        
        return false
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//
//        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    private func removeCommaFrom(_ string: String) -> String {
        return string.replacingOccurrences(of: ",", with: "")
    }
    
    private func addCommaTo(_ string: String) -> String {
        let components = string.components(separatedBy: CharacterSet(charactersIn: "."))
        let intPart = components[0]
        if intPart.count == 0 {
            return ""
        }
        let reversed = intPart.reversed()
        var res = ""
        for (index, elem) in reversed.enumerated() {
            if index != 0 && index % 3 == 0 {
                res.append(",")
            }
            res.append(elem)

        }
        var intString = String(res.reversed())
        if components.count > 1 {
            intString.append(".")
            intString.append(components[1])
        }
        return intString
    }
}

extension QuestionController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comment:"
            textView.textColor = UIColor.lightGray
        }
    }
}
