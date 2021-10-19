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
    
    var businessController = BusinessController()
    var trainingController = TrainingController()
    
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
        print("submit")
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
        default:
            currentVC = businessNavController
        }
        
        showDetailViewController(currentVC!, sender: self)
        hide(.primary)
        
    }
    
    
}
