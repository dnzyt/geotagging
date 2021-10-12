//
//  LoginController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit

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
        
        UserDefaults.standard.set(true, forKey: Defaults.authentication.rawValue)
        dismiss(animated: true)

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
