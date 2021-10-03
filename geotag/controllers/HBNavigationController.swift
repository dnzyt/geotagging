//
//  HBNavigationController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit

class HBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        var traitCollections: [UITraitCollection]?
        if view.bounds.width < view.bounds.height {
            traitCollections = [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)]
        } else {
            traitCollections = [UITraitCollection(horizontalSizeClass: .regular), UITraitCollection(verticalSizeClass: .compact)]
            
        }
        return UITraitCollection(traitsFrom: traitCollections!)
    }

}
