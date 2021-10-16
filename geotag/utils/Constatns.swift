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
    static let url = "https://4ea2949f-0a61-4c5c-b0e0-ff7defd83600.mock.pstmn.io"
    #else
    static let url = "PORD URL"
    #endif
}

enum Defaults: String {
    case authentication = "AUTHENTICATION"
    case questions_downloaded = "QUESTIONS_DOWNLOADED"
}
