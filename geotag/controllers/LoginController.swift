//
//  LoginController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit
import SwiftyJSON
import CoreData

class LoginController: UIViewController {
    
    var loginFormYContraint: NSLayoutConstraint?
    
    let logoView: UIImageView = {
        let l = UIImageView()
        l.image = UIImage(named: "horizon_logo")
        l.contentMode = .scaleAspectFit
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let usernameTF: UITextField = {
        let utf = UITextField()
        utf.placeholder = "Username"
        utf.translatesAutoresizingMaskIntoConstraints = false
        return utf
    }()
    
    let passwordTF: UITextField = {
        let ptf = UITextField()
        ptf.placeholder = "Password"
        ptf.translatesAutoresizingMaskIntoConstraints = false
        return ptf
    }()
    
    let spacer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let loginBTN: UIButton = {
        let lbtn = UIButton()
        lbtn.setTitle("Login", for: .normal)
        lbtn.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        lbtn.translatesAutoresizingMaskIntoConstraints = false
        
        lbtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return lbtn
    } ()
    
    @objc fileprivate func loginAction() {
        
        let url = URL(string: "https://mocki.io/v1/0b3af078-c561-4b74-9ab7-6e4406f0e75c")
        URLSession.shared.dataTask(with: url!) { data, response, error in
//            guard let data = data else { return }
            
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = QuestionInfo.fetchRequest()
                do {
                    let result = try context.fetch(fetchRequest) as [QuestionInfo]
                    result.forEach {q in
                        print("key: \(q.questionKey!)")
                        print("label: \(q.label!)")
                        for l in q.items! {
                            let label = l as! LabelInfo
                            print("label key: \(label.labelKey!)")
                            print("label value: \(label.labelValue!)")
                        }
                        print("----------")
                    }
                } catch {
                    print("fetch failed")
                }
                
//                let json = try! JSON(data: data)
//                print("json: \(json)")
//                for (_, subJson): (String, JSON) in json {
//                    let question = QuestionInfo(context: context)
//                    question.categoryId = subJson["categoryId"].stringValue
//                    question.label = subJson["label"].stringValue
//                    question.needComment = subJson["needComment"].stringValue
//                    question.questionKey = subJson["questionKey"].stringValue
//                    question.questionType = subJson["questionType"].stringValue
//                    let items = subJson["items"].arrayValue
//                    for i in items {
//                        let dropdownOption = LabelInfo(context: context)
//                        dropdownOption.labelKey = i["itemKey"].stringValue
//                        dropdownOption.labelValue = i["itemValue"].stringValue
//                        question.addToItems(dropdownOption)
//                    }
//                }
//                do {
//                    try context.save()
//                    print("saved")
//
//                } catch {
//                    print("saving failed")
//                }
            }
        }.resume()
        
        
//        UserDefaults.standard.set(true, forKey: Defaults.authentication.rawValue)
//        dismiss(animated: true)

    }
    
    let inputsContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.layer.cornerRadius = 5
        sv.layer.masksToBounds = true
        sv.backgroundColor = UIColor.white
        sv.alignment = .center
        
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputsView()
        
        view.backgroundColor = UIColor.hbGreen

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size.width < size.height {
            loginFormYContraint?.constant = 0
        } else {
            loginFormYContraint?.constant = -200
        }



    }
    
    fileprivate func setupInputsView() {
        view.addSubview(logoView)
        inputsContainer.addArrangedSubview(usernameTF)
        inputsContainer.addArrangedSubview(spacer)
        inputsContainer.addArrangedSubview(passwordTF)
        view.addSubview(inputsContainer)
        view.addSubview(loginBTN)
        
        loginFormYContraint = inputsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        NSLayoutConstraint.activate([
            logoView.widthAnchor.constraint(equalToConstant: 300),
            logoView.heightAnchor.constraint(equalToConstant: 120),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.bottomAnchor.constraint(equalTo: inputsContainer.topAnchor, constant: -10),
            inputsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginFormYContraint!,
            inputsContainer.widthAnchor.constraint(equalToConstant: 300),
            usernameTF.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, constant: -6),
            usernameTF.heightAnchor.constraint(equalToConstant: 44),
            spacer.heightAnchor.constraint(equalToConstant: 1),
            spacer.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, constant: -6),
            passwordTF.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, constant: -6),
            passwordTF.heightAnchor.constraint(equalToConstant: 44),
            loginBTN.topAnchor.constraint(equalTo: inputsContainer.bottomAnchor, constant: 10),
            loginBTN.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            loginBTN.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),
            loginBTN.heightAnchor.constraint(equalToConstant: 44)
        ])

    }

}

enum Defaults: String {
    case authentication = "AUTHENTICATION"
}
