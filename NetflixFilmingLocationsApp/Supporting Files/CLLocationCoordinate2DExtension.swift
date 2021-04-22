//
//  CLLocationCoordinate2DExtension.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
  
  func distanceInMetersFrom(otherCoord : CLLocationCoordinate2D) -> CLLocationDistance {
    let firstLoc = CLLocation(latitude: self.latitude, longitude: self.longitude)
    let secondLoc = CLLocation(latitude: otherCoord.latitude, longitude: otherCoord.longitude)
    return firstLoc.distance(from: secondLoc)
  }
  
  func distanceInMilesFrom(otherCoord : CLLocationCoordinate2D) -> CLLocationDistance {
    let distanceMeters = distanceInMetersFrom(otherCoord: otherCoord)
    return distanceMeters * 0.000621371
  }
  
}
