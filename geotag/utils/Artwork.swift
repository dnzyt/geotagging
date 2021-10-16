//
//  Artwork.swift
//  geotag
//
//  Created by Ningze Dai on 10/15/21.
//

import MapKit

class Artwork: NSObject, MKAnnotation {
    let club: ClubInfo?
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        locationName: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D,
        club: ClubInfo?
    ) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.club = club
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
