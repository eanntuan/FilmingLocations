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
  @IBOutlet fileprivate var posterImageArt: UIImageView!
  @IBOutlet fileprivate var reviewsLabel: UILabel!
  @IBOutlet fileprivate var actorsLabel: UILabel!
  @IBOutlet fileprivate var productionLabel: UILabel!
  
  var posterImage: UIImage?
  var film: Film?
  var filmDetails: ImdbFilm?
  var locationManager = CLLocationManager()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    posterImageArt.layer.cornerRadius = 3.5
    posterImageArt.clipsToBounds = true
  }
  
  func configure(_ film: Film, index: IndexPath) {
    self.film = film
    nameLabel.text = film.title
    actorsLabel.text = film.actorsString
    productionLabel.text = film.productionCompany
    distanceLabel.text = String("\(film.distanceToCurrentLocation) mi.")
    if let rating = self.filmDetails?.imdbRating, rating != "N/A" {
      reviewsLabel.text = "\(rating)/10"
    } else {
      reviewsLabel.text = "No reviews yet"
    }
  }
  
  func clearImage() {
    posterImageArt.image = .defaultImageIcon
  }
  
  func setImage(_ image: UIImage) {
    clearImage()
    posterImage = image
    posterImageArt.image = image
    posterImageArt.layer.cornerRadius = 10
  }
  
}

