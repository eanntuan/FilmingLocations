//
//  PlotCell.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation
import UIKit

class PlotCell: UICollectionViewCell, NibLoadedView {
  
  @IBOutlet weak var plotLabel: UILabel!
  
  var film: Film?
  var filmDetails: ImdbFilm?
  
  func configure(for film: Film, details: ImdbFilm?) {
    self.film = film
    self.filmDetails = details
    if let details = filmDetails?.plot {
      plotLabel.text = "\(details)"
    } else {
      plotLabel.text = ""
    }
    plotLabel.sizeToFit()
  }
}
