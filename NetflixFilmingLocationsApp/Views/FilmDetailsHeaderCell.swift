//
//  FilmDetailsHeaderCell.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation
import UIKit

class FilmDetailsHeaderCell: UICollectionViewCell, NibLoadedView {
  
  // MARK: Properties
  
  var film: Film!
  var filmDetails: ImdbFilm?
  var image: UIImage?
  
  // MARK: Outlets
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet fileprivate var nameLabel: UILabel!
  @IBOutlet fileprivate var numReviewsLabel: UILabel!
  @IBOutlet weak var directorLabel: UILabel!
  @IBOutlet weak var actorLabel: UILabel!
  
  func configure(_ film: Film, filmDetails: ImdbFilm?, image: UIImage) {
    translatesAutoresizingMaskIntoConstraints = false
    self.film = film
    self.filmDetails = filmDetails
    self.image = image
    
    nameLabel.text = film.title
    actorLabel.text = film.actorsString
    actorLabel.sizeToFit()
    directorLabel.text = film.director
    directorLabel.sizeToFit()
    
    if let rating = self.filmDetails?.imdbRating, rating != "N/A" {
      numReviewsLabel.text = "\(rating)/10"
    } else {
      numReviewsLabel.text = "No reviews yet"
    }
    
    if image == .defaultImageIcon {
      // Try to get the image
      if let filmImage = FilmManager.shared.imdbFilmsDict[film.title]?.poster, let imageUrl = URL(string: filmImage) {
        ImageCache.shared.image(url: imageUrl) { (image) in
          DispatchQueue.main.async {
            self.imageView.image = image
            self.imageView.layer.cornerRadius = 10
          }
        }
      }
    } else {
      imageView.image = image
      imageView.layer.cornerRadius = 10
    }
    
  }

}
