//
//  Location.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation
import MapKit
import UIKit

class LocationAnnotation: NSObject, MKAnnotation {
  
  var coordinate: CLLocationCoordinate2D
  var info: String?
  var film: Film?
  var atIndex: Int?
  var title: String?
  var subtitle: String?
  
  init(film: Film, coordinate: CLLocationCoordinate2D, at index: Int) {
    self.film = film
    self.coordinate = coordinate
    self.atIndex = index
    self.title = film.title
    self.subtitle = film.locations
  }
}
