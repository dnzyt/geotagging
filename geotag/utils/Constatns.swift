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
    static let url = "https://herbalife-oegdevws.hrbl.com/Distributor/NClubGeoTrackRS_prs"
    #else
    static let url = "https://herbalife-econnect.hrbl.com/Distributor/NClubGeoTrackRS"
    #endif
    static let getLabels = "/NClubGetLabelDetails"
    static let updateGeoTrack = "/NClubUpdateGeoTrackDtls"
    static let getClubs = "/NClubGetClubDetails"
    static let createVisit = "/NClubCreateVisitDetails"
    static let offlineDoneNotification = "offlineDoneNotification"
}

enum Defaults: String {
    case authentication = "AUTHENTICATION"
    case questions_downloaded = "QUESTIONS_DOWNLOADED"
    case language_code = "LANGUAGE_CODE"
}
