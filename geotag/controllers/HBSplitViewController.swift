//
//  HBSplitViewController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class HBSplitViewController: UISplitViewController {
    
    var visitInfo: VisitInfo?
    
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
    
    @objc fileprivate func submit() {
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
            if let comment = a.comment {
                temp["Comment"] = comment
            }
            temp["CategoryId"] = a.categoryId!
            var tempAns = [String]()
            
            for idx in a.ans! {
                let ddi = a.items?.object(at: idx) as! DropDownItem
                tempAns.append(ddi.labelKey!)
            }
            temp["Answers"] = tempAns
            ans.append(temp)
        }
        dict["Questions"] = ans
        print("request body: \(dict)")
    }
    
    fileprivate func backToHome() {
        guard let window = self.view.window else { return }
        let nav = HBNavigationController(rootViewController: HomeController())
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = nav
        }
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
        hide(.primary)
        
    }
    
    
}
