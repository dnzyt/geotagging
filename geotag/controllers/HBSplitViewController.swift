//
//  HBSplitViewController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit
import SwiftyJSON
import JGProgressHUD
import Reachability


class HBSplitViewController: UISplitViewController {
    
    var visitInfo: VisitInfo?
    let hud = JGProgressHUD()

    var menuController: MenuController?
    private var businessNavController: UINavigationController?
    private var trainingNavController: UINavigationController?
    private var trackingNavController: UINavigationController?
    private var feedbackNavController: UINavigationController?
    
    var businessController = BusinessController()
    var trainingController = TrainingController()
    var trackingController = TrackingController()
    var feedbackController = FeedbackController()
    
    var cancelVisitBtn: UIBarButtonItem?
    var submitBtn: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelVisitBtn = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(cacelVisit))
        cancelVisitBtn!.tintColor = .hbPink
        
        submitBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(submit))
        submitBtn?.tintColor = .white
        
        menuController = MenuController()
        menuController?.delegate = self
        
        
        
        businessController.navigationItem.leftBarButtonItem = cancelVisitBtn
        businessController.navigationItem.rightBarButtonItem = submitBtn
        businessNavController = UINavigationController(rootViewController: businessController)
        
        
        trainingController.navigationItem.leftBarButtonItem = cancelVisitBtn
        trainingController.navigationItem.rightBarButtonItem = submitBtn
        trainingNavController = UINavigationController(rootViewController: trainingController)
        
        trackingController.navigationItem.leftBarButtonItem = cancelVisitBtn
        trackingController.navigationItem.rightBarButtonItem = submitBtn
        trackingNavController = UINavigationController(rootViewController: trackingController)
        
        feedbackController.navigationItem.leftBarButtonItem = cancelVisitBtn
        feedbackController.navigationItem.rightBarButtonItem = submitBtn
        feedbackNavController = UINavigationController(rootViewController: feedbackController)
        
        
        
        
        
        
        setViewController(menuController, for: .primary)
        setViewController(businessNavController, for: .secondary)
        
        self.delegate = self
    }
    
    @objc fileprivate func cacelVisit() {
        print("delete visit")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let alert = UIAlertController(title: "Leave Visit", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            self?.visitInfo?.finished = false
            self?.visitInfo?.submitted = false
            
            do {
                try context.save()
            } catch {
                print("save visit info failed")
            }
            
            self?.backToHome()
        }))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { [weak self] _ in
            
            context.delete(self!.visitInfo!)
            do {
                try context.save()
            } catch {
                print("delete visit info failed")
            }
            self?.backToHome()
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func submit() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        var result = true

        visitInfo!.answers!.enumerateObjects { elem, idx, stop in
            let a = elem as! AnswerInfo
            guard let qType = a.questionType else {
                stop.pointee = true
                return
            }
            var category: Int? = -1
            var errorMessage: String? = ""
            if qType == "MULTI_SELECT" {
                (result, category, errorMessage) = validateDropdown(answer: a)
            } else if qType == "SINGLE_SELECT" {
                (result, category, errorMessage) = validateDropdown(answer: a)
            } else if qType == "USER_ENTRY" {
                (result, category, errorMessage) = validateTextBox(answer: a)
            }

            if !result {
                if let menuController = menuController {
                    menuController.menuTable.selectRow(at: IndexPath(item: category!, section: 0), animated: true, scrollPosition: .none)
                    menuController.tableView(menuController.menuTable, didSelectRowAt: IndexPath(item: category!, section: 0))
                }
                let alert = UIAlertController(title: "Incomplete Answers", message: errorMessage, preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alert.addAction(dismissAction)
                present(alert, animated: true, completion: nil)
                stop.pointee = true
                return
            }
        }
        if !result {
            return
        }
        visitInfo?.finished = true
        try? context.save()
        
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            showOfflineAlert()
            return
        }
        
        self.hud.textLabel.text = "Submitting visit..."
        self.hud.detailTextLabel.text = nil
        self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        self.hud.show(in: self.view)
        
        guard let url = URL(string: Constatns.url + Constatns.createVisit) else { return }
        let dict = prepareRequestBody()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // show error message and then go back
                self.showFailureAlert()
                return
            }
            if let data = data {
                do {
                    let json = try JSON(data: data)
                    print("create visit response json: \(json)")
                    if let errorCode = json["ErrorCode"].string, errorCode == "0" {
                        self.showSuccessAlert(visitNumber: json["VisitNumber"].stringValue)
                    } else {
                        self.showFailureAlert()
                    }
                } catch {
                    self.showFailureAlert()
                }
                return
            } else {
                self.showFailureAlert()
            }
            
        }.resume()
        
    }
    
    private func showOfflineAlert() {
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Visit cached locally"
            self.hud.detailTextLabel.text = "The app is in offline mode currently."
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 3, animated: true) { [weak self] in
                self?.backToHome()
            }
        }
    }
    
    private func showFailureAlert() {
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Visit submission failed."
            self.hud.detailTextLabel.text = "Server cannot process this visit."
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.dismiss(afterDelay: 3, animated: true) { [weak self] in
                self?.backToHome()
            }
        }
    }
    
    private func showSuccessAlert(visitNumber: String) {
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Visit submission successful."
            self.hud.detailTextLabel.text = "Visit number: \(visitNumber)"
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 3, animated: true) { [weak self] in
                self?.backToHome()
            }
        }
    }
    
    private func backToHome() {
        guard let window = self.view.window else { return }
        let nav = HBNavigationController(rootViewController: HomeController())
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = nav
        }
    }
    
    private func validateDropdown(answer: AnswerInfo) -> (Bool, Int?, String?) {
        if answer.ans!.count == 0 {
            return (false, Int(answer.categoryId!)! - 1, "Select one option from the menu at least.")
        }
        
        for idx in answer.ans! {
            let ddi = answer.items?.object(at: idx) as! DropDownItem
            if ddi.labelKey! == "OTHERS" {
                if let comment = answer.comment {
                    if comment.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                        return (false, Int(answer.categoryId!)! - 1, "Comment is mandatory when Other is selected.")
                    }
                } else {
                    return (false, Int(answer.categoryId!)! - 1, "Comment is mandatory when Other is selected.")
                }
            }
        }
        
        return (true, nil, nil)
    }
    
    private func validateTextBox(answer: AnswerInfo) -> (Bool, Int?, String?) {
        
        if let textBox = answer.textBox {
            if textBox.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return (false, Int(answer.categoryId!)!, "User input cannot be empty for this question.")
            }
        } else {
            return (false, Int(answer.categoryId!)!, "User input cannot be empty for this question.")
        }
        
        return (true, nil, nil)
    }
    
    private func prepareRequestBody() -> [String: Any] {
        var dict = [String: Any]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        dict["ClubKey"] = visitInfo!.clubKey!
        dict["VisitDate"] = dateFormatter.string(from:(visitInfo!.visitDate!))
        var ans = [Any]()
        visitInfo!.answers!.enumerateObjects { elem, idx, _ in
            let a = elem as! AnswerInfo
            var temp = [String: Any]()
            temp["QuestionType"] = a.questionType!
            temp["QuestionKey"] = a.questionKey!
            temp["Comment"] = a.comment ?? ""
            temp["CategoryId"] = a.categoryId!
            var tempAns = [String]()
            if a.questionType == "USER_ENTRY" {
                a.ans?.append(0)
                temp["OtherTextBox"] = a.textBox!
            }

            for idx in a.ans! {
                let ddi = a.items?.object(at: idx) as! DropDownItem
                tempAns.append(ddi.labelKey!)
            }
            temp["Answers"] = tempAns
            ans.append(temp)
        }
        dict["Questions"] = ans
        print("request body: \(dict)")
        
        return dict
    }
    
    
    
}

extension HBSplitViewController: UISplitViewControllerDelegate {
    
}

extension HBSplitViewController: MenuControllerDelegate {
    func menuTable(_ menuTable: UITableView, didSelectItemAt index: Int) {
        var currentVC: UIViewController?
        switch index {
        case 0:
            currentVC = businessNavController
        case 1:
            currentVC = trainingNavController
        case 2:
            currentVC = trackingNavController
        case 3:
            currentVC = feedbackNavController
        default:
            currentVC = businessNavController
        }
        
        showDetailViewController(currentVC!, sender: self)
        
    }
    
    func hideMenu() {
        hide(.primary)
    }
    
    
}
