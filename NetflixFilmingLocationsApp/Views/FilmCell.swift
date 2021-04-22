//
//  FilmCell.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import UIKit
import CoreLocation

class FilmCell: UITableViewCell, CLLocationManagerDelegate {
  
  @IBOutlet fileprivate var distanceLabel: UILabel!
  @IBOutlet fileprivate var nameLabel: UILabel!
  @IBOutlet fileprivate var listingImageView: UIImageView!
  @IBOutlet fileprivate var ratingImageView: UIImageView!
  @IBOutlet fileprivate var reviewsLabel: UILabel!
  @IBOutlet fileprivate var actorsLabel: UILabel!
  @IBOutlet fileprivate var productionLabel: UILabel!
  
  var film: Film?
  var locationManager = CLLocationManager()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    listingImageView.layer.cornerRadius = 3.5
    listingImageView.clipsToBounds = true
  }
  
  func configure(_ film: Film, index: IndexPath) {
    self.film = film
    nameLabel.text = film.title
    actorsLabel.text = film.actorsString
    productionLabel.text = film.productionCompany
    distanceLabel.text = String("\(film.distanceToCurrentLocation) mi.")
  }
  
}

