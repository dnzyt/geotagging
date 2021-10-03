//
//  HBSplitViewController.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class HBSplitViewController: UISplitViewController {
    
    var menuController: MenuController?
    var businessController: BusinessController?
    var trainingController: TrainingController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuController = MenuController()
        menuController?.delegate = self
        businessController = BusinessController()
        trainingController = TrainingController()
        
        setViewController(menuController, for: .primary)
        setViewController(UINavigationController(rootViewController: businessController!), for: .secondary)
        
        self.delegate = self
    }

}

extension HBSplitViewController: UISplitViewControllerDelegate {
}

extension HBSplitViewController: MenuControllerDelegate {
    func menuTable(_ menuTable: UITableView, didSelectItemAt index: Int) {
        var currentVC: UIViewController?
        switch index {
        case 0:
            currentVC = businessController
        case 1:
            currentVC = trainingController
        default:
            currentVC = businessController
        }
        
        showDetailViewController(UINavigationController(rootViewController: currentVC!), sender: self)
        
    }
}
