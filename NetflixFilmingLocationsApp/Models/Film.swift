//
//  Film.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/20/21.
//

import Foundation
import MapKit

struct FilmLocation: Codable, Equatable {
  var actors: [String]
  var longitude: Float
  var title: String
  var locations: String
  var latitude: Float
  var writers: [String]?
  var director: String
  var productionCompany: String
  var releaseYear: String
  var funFacts: String?
}

struct Film: Equatable {
  var actors: [String]
  var longitude: Float
  var title: String
  var locations: String
  var latitude: Float
  var writers: [String]?
  var director: String
  var productionCompany: String
  var releaseYear: String
  var funFacts: String?
  
  var genre: String?
  var poster: String?
  var imdbID: String?
  var imdbRating: String?
  
  var image: UIImage?
  
  var actorsString: String {
    return actors.joined(separator:", ")
  }
  
  var latitudeCoordinate: CLLocationDegrees {
    return CLLocationDegrees(self.latitude)
  }
  
  var longitudeCoordinate: CLLocationDegrees {
    return CLLocationDegrees(self.longitude)
  }
  
  var locationCoordinate: CLLocation {
    return CLLocation(latitude: self.latitudeCoordinate, longitude: self.longitudeCoordinate)
  }
  
  var coordinate2D: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(latitudeCoordinate, longitudeCoordinate)
  }
  
  var distanceToCurrentLocation: Double {
    let currentLat = 37.7749 //location.coordinate.latitude
    let currentLong = -122.4194 //location.coordinate.longitude
    
    let myLocation = CLLocation(latitude: currentLat, longitude: currentLong)
    let distanceMeters = myLocation.distance(from: self.locationCoordinate)
    let distanceMiles = distanceMeters * 0.000621371
    return Double(round(100 * distanceMiles) / 100)
  }
  
  static func == (lhs: Film, rhs: Film) -> Bool {
    return lhs.title == rhs.title && lhs.locations == rhs.locations
  }
}

struct FilmTitleToLocationsCache: Codable {
  let dateCached: Date
  var filmTitleDict: [String: [FilmLocation]]
  
  init() {
    self.filmTitleDict = [:]
    self.dateCached = Date()
  }
}

struct Location {
  var locationCoordinate: CLLocation?
  var coordinate2D: CLLocationCoordinate2D?
  var locationName: String?
}
