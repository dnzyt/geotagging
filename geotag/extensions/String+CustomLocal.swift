//
//  String+CustomLocal.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//

import UIKit

extension String {
    func localized(forLanguageCode lanCode: String) -> String {
        guard
            let bundlePath = Bundle.main.path(forResource: lanCode, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath)
        else { return "" }
        
        return NSLocalizedString(
            self,
            bundle: bundle,
            value: "    ",
            comment: ""
        )
    }
}
