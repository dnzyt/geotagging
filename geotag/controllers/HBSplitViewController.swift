//
//  HBSplitViewController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class HBSplitViewController: UISplitViewController {
    
    var menuController: MenuController?
    var businessNavController: UINavigationController?
    var trainingNavController: UINavigationController?
    
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
        
        
        let businessController = BusinessController()
        businessController.navigationItem.leftBarButtonItem = cancelVisitBtn
        businessController.navigationItem.rightBarButtonItem = submitBtn
        businessNavController = UINavigationController(rootViewController: businessController)
        
        let trainingController = TrainingController()
        trainingController.navigationItem.leftBarButtonItem = cancelVisitBtn
        trainingController.navigationItem.rightBarButtonItem = submitBtn
        trainingNavController = UINavigationController(rootViewController: trainingController)

        
        
        
        setViewController(menuController, for: .primary)
        setViewController(businessNavController, for: .secondary)
        
        self.delegate = self
        
        
        
        
    }
    
    @objc fileprivate func cacelVisit() {
        print("cancel visit")
        backToHome()
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
