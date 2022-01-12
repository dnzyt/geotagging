//
//  LoginController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit
import SwiftyJSON
import CoreData
import JGProgressHUD

class LoginController: UIViewController {
    
    var loginFormYContraint: NSLayoutConstraint?
    let hud = JGProgressHUD()
    
    let versionLbl: UILabel = {
        let vl = UILabel()
        vl.translatesAutoresizingMaskIntoConstraints = false
        vl.text = "v0.4.2"
        vl.textColor = .white
        return vl
    }()
    
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
        ptf.isSecureTextEntry = true
        
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
        UserDefaults.standard.set("id", forKey: Defaults.language_code.rawValue)
                
        let questionsDownloaded = UserDefaults.standard.bool(forKey: Defaults.questions_downloaded.rawValue)
        if !questionsDownloaded {
            downloadQuestions()
        }
        authenticateUser()

    }
    
    private func authenticateUser() {
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Authenticating..."
            self.hud.detailTextLabel.text = nil
            self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
            self.hud.show(in: self.view)
        }
        guard let username = usernameTF.text else { return }
        guard let password = passwordTF.text else { return }
        
        var dict = [String: String]()
        dict["userName"] = username
        dict["password"] = password
        
        guard let url = URL(string: "https://herbalife-econnectslc.hrbl.com:8443/CommonServices/rest/login/ldapLogin") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                DispatchQueue.main.async {
                    self.hud.textLabel.text = "Autentication Failed"
                    self.hud.detailTextLabel.text = "Cannot connect to the server, please try again later"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.indicatorView?.tintColor = .systemRed
                    self.hud.dismiss(afterDelay: 2)
                }
                return
            }
            
            let json = try! JSON(data: data!)
            print("json: \(json)")
            if let _ = json["errorMessage"].string {
                print("authentication failed")
                DispatchQueue.main.async {
                    self.hud.textLabel.text = "Autentication Failed"
                    self.hud.detailTextLabel.text = nil
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.indicatorView?.tintColor = .systemRed
                    self.hud.dismiss(afterDelay: 2)
                }
                return
            } else {
                UserDefaults.standard.set(true, forKey: Defaults.authentication.rawValue)
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }.resume()
        
        
    }
    
    private func downloadQuestions() {
        print("service url: \(Constants.url + Constants.getLabels)")
        guard let url = URL(string: Constants.url + Constants.getLabels) else { return }
        var dict = [String: String]()
        dict["CountryCode"] = "ID"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.showDownloadingFailed()
                }
                return
                
            }
            if let data = data {
                do {
                    let json = try JSON(data: data)
                    print("json: \(json)")
                    
                    DispatchQueue.main.async {
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                        let context = appDelegate.persistentContainer.viewContext
                        
                        var index = 0
                        
                        if let errorCode = json["ErrorCode"].string, errorCode == "0" {
                            if let newJson = json["Labels"].array {
                                for subJson in newJson {
                                    let question = QuestionInfo(context: context)
                                    question.categoryId = subJson["CategoryId"].stringValue
                                    question.orderIndex = Int16(index)
                                    index += 1
                                    question.label = subJson["Label"].stringValue
                                    question.needComment = subJson["NeedComment"].stringValue
                                    question.questionKey = subJson["QuestionKey"].stringValue
                                    question.questionType = subJson["QuestionType"].stringValue
                                    if let items = subJson["Items"].array {
                                        for i in items {
                                            let dropdownOption = LabelInfo(context: context)
                                            dropdownOption.labelKey = i["ItemKey"].stringValue
                                            dropdownOption.labelValue = i["ItemValue"].stringValue
                                            question.addToItems(dropdownOption)
                                        }
                                    }
                                }
                                do {
                                    try context.save()
                                    UserDefaults.standard.set(true, forKey: Defaults.questions_downloaded.rawValue)
                                } catch {
                                    print("saving questions failed")
                                    self.showDownloadingFailed()
                                }
                            } else {
                                self.showDownloadingFailed()
                            }
                        } else {
                            self.showDownloadingFailed()
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.showDownloadingFailed()
                    }
                }
            }
        }.resume()
        
    }
    

    private func showDownloadingFailed() {
        let alert = UIAlertController(title: "Server Error", message: "Server is not responding, please logout and try again later.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
        view.addSubview(versionLbl)
        view.addSubview(logoView)
        inputsContainer.addArrangedSubview(usernameTF)
        inputsContainer.addArrangedSubview(spacer)
        inputsContainer.addArrangedSubview(passwordTF)
        view.addSubview(inputsContainer)
        view.addSubview(loginBTN)
        
        loginFormYContraint = inputsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        NSLayoutConstraint.activate([
            versionLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            versionLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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


