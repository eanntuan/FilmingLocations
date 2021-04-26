//
//  FilmsMapViewController.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation
import UIKit
import MapKit

class FilmsMapViewController: UIViewController {
  
  // MARK: Outlets
  
  @IBOutlet fileprivate var mapView: MKMapView!
  
  // MARK: Stored Properties
  
  fileprivate var annotations = [MKAnnotation]()
  var filteredFilms = [Film]()
  
  let searchController = UISearchController(searchResultsController: nil)
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  
  // MARK: Property Observers
  
  var films = [Film]() {
    didSet {
      print("there are \(films.count) in FilmsMapViewController")
      addAnnotationsToMap(films)
    }
  }
  
  var filmObserver: Any?
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    filmObserver = NotificationCenter.default.addObserver(forName: .DidGetFilms, object: nil, queue: .main) { [weak self] (_) in
        self?.reloadData()
    }
    films = FilmManager.shared.films
    films.isEmpty ? FilmManager.shared.getFilms() : nil
    setupSearchBar()
  }
  
  func reloadData() {
    films = FilmManager.shared.films
    mapView.reloadInputViews()
  }
  
  fileprivate func addAnnotationsToMap(_ films: [Film]) {
    if annotations.count > 0 { mapView.removeAnnotations(annotations) }
    annotations.removeAll()
    for (index, film) in films.enumerated() {
      let annotation = LocationAnnotation(film: film, coordinate: film.coordinate2D, at: index)
      annotations.append(annotation)
    }
    mapView.addAnnotations(annotations)
    mapView.showAnnotations(annotations, animated: true)
  }
  
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search for a movie title or actor"
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.becomeFirstResponder()
    navigationItem.searchController = searchController
  }
  
  func filterContentForSearchText(_ searchText: String) {
    filteredFilms = films.filter { (film: Film) -> Bool in
      return film.title.lowercased().contains(searchText.lowercased()) || film.actorsString.lowercased().contains(searchText.lowercased())
    }
    addAnnotationsToMap(filteredFilms)
  }
  
}

// MARK: - MKMapViewDelegate

extension FilmsMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "pin"
    var view: MKPinAnnotationView
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        as? MKPinAnnotationView {
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else {
      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = true
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
    }
    return view
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let annotation = view.annotation as? LocationAnnotation else { return }
    if let filmsDetailVC = UIStoryboard(name: "Films", bundle: nil).instantiateViewController(withIdentifier: "FilmDetailsCollectionViewController") as? FilmDetailsCollectionViewController, let index = annotation.atIndex {
      let film = films[index]
      filmsDetailVC.film = film
      filmsDetailVC.image = .defaultImageIcon
      
      if let details = FilmManager.shared.imdbFilmsDict[film.title] {
        filmsDetailVC.filmDetails = details
      }
      self.navigationController?.pushViewController(filmsDetailVC, animated: true)
    }
  }
  
}

extension FilmsMapViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    if let text = searchBar.text {
      filterContentForSearchText(text)
    }
  }
  
}
