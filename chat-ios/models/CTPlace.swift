//
//  CTPlace.swift
//  chat-ios
//
//  Created by Brian Correa on 6/19/16.
//  Copyright © 2016 Velocity360. All rights reserved.
//

import UIKit
import MapKit

class CTPlace: NSObject, MKAnnotation {
    
    var id: String!
    var name: String!
    var city: String!
    var state: String!
    var address: String!
    var zip: String!
    var lat: Double!
    var lng: Double!
    
    func populate(placeInfo: Dictionary<String, AnyObject>){
        
        let keys = ["name", "city", "state", "address", "zip", "id"]
        for key in keys {
            let value = placeInfo[key]
            self.setValue(value, forKey: key)
        }
        
        if let _geo = placeInfo["geo"] as? Array<Double> {
            self.lat = _geo[0]
            self.lng = _geo[1]
        }
        
    }
    
    // MARK: - MKAnnotation Overrides
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return self.address
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.lat, self.lng)
    }
    
}