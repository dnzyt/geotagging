//
//  Constatns.swift
//  geotag
//
//  Created by Ningze Dai on 10/14/21.
//

import Foundation

struct Constatns {
    static let authentication = "AUTHENTICATION"
    #if DEV
    static let url = "DEV URL"
    #else
    static let url = "PORD URL"
    #endif
}
