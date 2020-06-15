//
//  Places.swift
//  toVisitPlaces_Ikroop_C0774174
//
//  Created by VirkIkroop on 2020-06-15.
//  Copyright © 2020 VirkIkroop. All rights reserved.
//

import Foundation

class Places{
    
    var placeLat: Double
    var placeLong: Double
    var placeName :String
    var city :String
    var postalCode : String
    var country : String
    
    init(placeLat:Double , placeLong: Double, placeName:String, city:String, postalCode: String, country:String) {
        self.placeLat = placeLat
        self.placeLong = placeLong
        self.placeName = placeName
        self.city = city
        self.postalCode = postalCode
        self.country = country
    }
    
    
}
