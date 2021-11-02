//
//  ClubSearchController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit
import SwiftyJSON
import CoreLocation

protocol ClubSearchControllerDelegate: AnyObject {
    func searchStarted()
    func clubsSearched(_ clubs: [ClubInfo], withResult res: Bool, and message: String?)
}


class ClubSearchController: UIViewController {

    static let clubKeyTag = 1
    static let memberIdTag = 2
    
    
    weak var delegate: ClubSearchControllerDelegate?
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
        var dict = [String: String]()
        if let content = searchContent {
            if activeField == 1 {
                dict["ClubKey"] = content
                dict["DistributorId"] = ""
            } else if activeField == 2 {
                dict["ClubKey"] = ""
                dict["DistributorId"] = content.uppercased()
            }
            delegate?.searchStarted()
        } else {
            return
        }
        
        
        
        guard let url = URL(string: Constatns.url + Constatns.getClubs) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                self.delegate?.clubsSearched([], withResult: false, and: "Internal Server Error")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let context = appDelegate.persistentContainer.viewContext
                    
                    var existingClubs = [ClubInfo]()
                    let fetchRequest = ClubInfo.fetchRequest()
                    do {
                        let result = try context.fetch(fetchRequest) as [ClubInfo]
                        existingClubs.append(contentsOf: result)
                    } catch {
                        print("load clubs from local failed")
                    }
                    
                    
                    let json = try! JSON(data: data)
                    print("json: \(json)")
                    if let errorCode = json["ErrorCode"].string, errorCode == "0", let errorMessage = json["ErrorMessage"].string {
                        var res = [ClubInfo]()
                        let newJson = json["GetClubDetails"].arrayValue
                        for subJson in newJson {
                            let ck = subJson["clubKey"].stringValue
                            var exists = false
                            for club in existingClubs {
                                if let clubKey = club.clubKey {
                                    if clubKey == ck {
                                        exists = true
                                        break
                                    }
                                }
                            }
                            if exists {
                                continue
                            }
                            
                            let club = ClubInfo(context: context)
                            club.clubKey = subJson["ClubKey"].stringValue
                            club.clubName = subJson["ClubName"].stringValue
                            club.address = subJson["Address"].stringValue
                            club.city = subJson["City"].stringValue
                            club.province = subJson["Province"].stringValue
                            club.zip = subJson["Zip"].stringValue
                            club.phone = subJson["Phone"].stringValue
                            club.clubType = subJson["ClubType"].stringValue
                            club.clubStatus = subJson["ClubStatus"].stringValue
                            club.openDate = subJson["Opendate"].stringValue
                            club.primaryDsId = subJson["PrimaryDsId"].stringValue
                            club.primaryDsName = subJson["PrimaryDsName"].stringValue
                            club.uplineName = subJson["UplineName"].stringValue
                            if let geocode = subJson["GeoCode"].string, geocode != "" {
                                club.geocode = geocode
                            }
                            res.append(club)
                        }
                        
                        do {
                            try context.save()
                            self.delegate?.clubsSearched(res, withResult: true, and: nil)

                        } catch {
                            print("saving clubs failed")
                            self.delegate?.clubsSearched(res, withResult: false, and: errorMessage)

                        }
                    } else {
                        self.delegate?.clubsSearched([], withResult: false, and: "Internal Server Error")
                    }
                }
            }
        }.resume()


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
