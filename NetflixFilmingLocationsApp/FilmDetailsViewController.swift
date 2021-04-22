//
//  FilmDetailsViewController.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation
import UIKit
import MapKit

class FilmDetailsViewController: UITableViewController {
  
  // MARK: Outlets
  
  @IBOutlet fileprivate var nameLabel: UILabel!
  @IBOutlet fileprivate var ratingImageView: UIImageView!
  @IBOutlet fileprivate var categoriesLabel: UILabel!
  @IBOutlet fileprivate var numReviewsLabel: UILabel!
  @IBOutlet fileprivate var isClosedLabel: UILabel!
  @IBOutlet fileprivate var businessImageView: UIImageView!
  @IBOutlet fileprivate var displayAddressLabel: UILabel!
  @IBOutlet fileprivate var displayPhoneLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var funFactsLabel: UILabel!
  
  // MARK: Stored Properties
  
  var film: Film!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 50
  }
  
  // MARK: Helpers
  
  fileprivate func setupViews() {
    setupLabels()
    setupImageViews()
    setupAnnotation()
  }
  
  fileprivate func setupAnnotation() {
    let annotation = MKPointAnnotation()
    annotation.coordinate = film.coordinate2D
    mapView.addAnnotation(annotation)
    mapView.showAnnotations([annotation], animated: true)
  }
  
  fileprivate func setupLabels() {
    self.nameLabel.text = film.title
    displayAddressLabel.text = film.locations
    funFactsLabel.text = film.funFacts ?? ""
    //      self.numReviewsLabel.text = "\(business.reviewCount ?? 0) Reviews"
    //      self.categoriesLabel.text = business.categories
    
    //      if let isClosed = business.isClosed, isClosed {
    //          isClosedLabel.text = "Closed"
    //          isClosedLabel.textColor = .red
    //      } else {
    //          isClosedLabel.text = "Open"
    //          isClosedLabel.textColor = .green
    //      }
    //      displayAddressLabel.text = business.address
    //      displayPhoneLabel.text = business.displayPhone
  }
  
  fileprivate func setupImageViews() {
    //      if let ratingImageURL = business.ratingImageURL {
    //          self.ratingImageView.setImageWith(ratingImageURL)
    //      }
    //
    //      if let imageURL = business.imageURL {
    //          businessImageView.setImageWith(imageURL)
    //      }
  }
  
  
}
