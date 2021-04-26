//
//  LocationCell.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/22/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class LocationCell: UICollectionViewCell, NibLoadedView, CLLocationManagerDelegate {
  
  @IBOutlet weak var seeLocationButton: UIButton!
  @IBOutlet weak var locationName: UILabel!
  @IBOutlet weak var distance: UILabel!
  
  var film: Film!
  
  func configure(_ film: Film) {
    self.film = film
    locationName.text = film.locations
    distance.text = "\(film.distanceToCurrentLocation) mi."
  }
  
  @IBAction func didTapLocation(_ sender: Any) {
    // Hardcoded for current location to be SF
    let currentLat = 37.7749 //location.coordinate.latitude
    let currentLong = -122.4194 //location.coordinate.longitude
    
    let myLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(currentLat), longitude: CLLocationDegrees(currentLong))
    let source = MKMapItem(placemark: MKPlacemark(coordinate: myLocation))
    source.name = "Current Location"
            
    let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: film.latitudeCoordinate, longitude: film.longitudeCoordinate)))
    destination.name = film.title
            
    MKMapItem.openMaps(
      with: [source, destination],
      launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    )
  }
}
