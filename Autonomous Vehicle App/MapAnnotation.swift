//
//  MapAnnotations.swift
//  Autonomous Vehicle App
//
//  Created by Ben Gilliam, JMU '18 on 1/24/18.
//

import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
