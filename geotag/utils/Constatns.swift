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
    static let url = "https://herbalife-oegdevws.hrbl.com/Distributor/NClubGeoTrackRS"
    #else
    static let url = "PORD URL"
    #endif
    static let getLabels = "/NClubGetLabelDetails"
    static let updateGeoTrack = "/NClubUpdateGeoTrackDtls"
    static let getClubs = "/NClubGetClubDetails"
    static let createVisit = "/NClubCreateVisitDetails"
}

enum Defaults: String {
    case authentication = "AUTHENTICATION"
    case questions_downloaded = "QUESTIONS_DOWNLOADED"
    case language_code = "LANGUAGE_CODE"
}
