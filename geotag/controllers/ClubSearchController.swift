//
//  ClubSearchController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit

class ClubSearchController: UIViewController {
    static let clubKeyTag = 1
    static let memberIdTag = 2
    
    var searchContent: String?
    var activeField = 0
    
    let clubKeyTF: UITextField = {
        let utf = UITextField()
        utf.placeholder = "Club Key"
        utf.translatesAutoresizingMaskIntoConstraints = false
        utf.tag = ClubSearchController.clubKeyTag

        return utf
    }()
    
    let memberIdTF: UITextField = {
        let ptf = UITextField()
        ptf.placeholder = "Member ID"
        ptf.translatesAutoresizingMaskIntoConstraints = false
        ptf.tag = ClubSearchController.memberIdTag
        return ptf
    }()
    
    let spacer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let searchBTN: UIButton = {
        let lbtn = UIButton()
        lbtn.setTitle("Search", for: .normal)
        lbtn.backgroundColor = .hbOrange
        lbtn.translatesAutoresizingMaskIntoConstraints = false
        
        lbtn.layer.cornerRadius = 5
        lbtn.layer.masksToBounds = true
        
        lbtn.addTarget(self, action: #selector(searchClub), for: .touchUpInside)
        return lbtn
    } ()
    
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
    
    let completion: (String) -> Void
    
    init(completion: @escaping (String) -> Void) {
        self.completion = completion

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        clubKeyTF.delegate = self
        memberIdTF.delegate = self
        
        setupInputsView()

    }
    
    fileprivate func setupInputsView() {
        inputsContainer.addArrangedSubview(clubKeyTF)
        inputsContainer.addArrangedSubview(spacer)
        inputsContainer.addArrangedSubview(memberIdTF)
        view.addSubview(inputsContainer)
        view.addSubview(searchBTN)
        
        NSLayoutConstraint.activate([
            inputsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            inputsContainer.widthAnchor.constraint(equalToConstant: 300),
            clubKeyTF.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, constant: -6),
            clubKeyTF.heightAnchor.constraint(equalToConstant: 44),
            spacer.heightAnchor.constraint(equalToConstant: 1),
            spacer.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, constant: -6),
            memberIdTF.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, constant: -6),
            memberIdTF.heightAnchor.constraint(equalToConstant: 44),
            searchBTN.topAnchor.constraint(equalTo: inputsContainer.bottomAnchor, constant: 10),
            searchBTN.leadingAnchor.constraint(equalTo: inputsContainer.leadingAnchor),
            searchBTN.trailingAnchor.constraint(equalTo: inputsContainer.trailingAnchor),
            searchBTN.heightAnchor.constraint(equalToConstant: 44)
        ])

    }
    
    @objc func searchClub() {
        if let content = searchContent {
            if activeField == 1 {
                print("fetching by club key ...")
                completion(content)
            } else if activeField == 2 {
                print("fetching by member id ...")
                completion(content)
            }
        }


        dismiss(animated: true)
    }
}

extension ClubSearchController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == ClubSearchController.clubKeyTag {
            memberIdTF.text = ""
            activeField = ClubSearchController.clubKeyTag
        } else if textField.tag == ClubSearchController.memberIdTag {
            clubKeyTF.text = ""
            activeField = ClubSearchController.memberIdTag
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let r = Range(range, in: text) {
            searchContent = text.replacingCharacters(in: r, with: string).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return true
    }
}
