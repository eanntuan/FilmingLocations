//
//  FilmLocationMapCell.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation
import UIKit
import MapKit

class FilmLocationMapCell: UICollectionViewCell, NibLoadedView {
  
  @IBOutlet weak var funFactLabel: UILabel!
  @IBOutlet fileprivate var addressLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  func configure(_ film: Film) {
    addressLabel.text = film.locations
    addressLabel.sizeToFit()
    if let facts = film.funFacts, !facts.isEmpty {
      funFactLabel.text = "Did you know? \(facts)"
      funFactLabel.sizeToFit()
    }
    setupAnnotation(for: film)
  }
  
  fileprivate func setupAnnotation(for film: Film) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = film.coordinate2D
    mapView.addAnnotation(annotation)
    mapView.showAnnotations([annotation], animated: true)
    mapView.layer.cornerRadius = 10
  }
}
