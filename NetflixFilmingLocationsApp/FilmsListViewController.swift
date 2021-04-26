//
//  FilmsViewController.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation
import UIKit

class FilmsListViewController: UIViewController {
  
  // MARK: Outlets
  
  @IBOutlet var tableView: UITableView!
  
  // MARK: Stored Properties
  
  fileprivate var isDownloadingMoreData = false
  fileprivate var footerActivityIndicatorView: UIView!
  var films = [Film]()
  var filteredFilms = [Film]()
  
  var filmObserver: Any?
  
  let searchController = UISearchController(searchResultsController: nil)
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  var segmentedController: UISegmentedControl!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVCViews()
    setupDelegates()
    films = FilmManager.shared.films
    films.isEmpty ? FilmManager.shared.getFilms() : nil
    filmObserver = NotificationCenter.default.addObserver(forName: .DidGetFilms, object: nil, queue: .main) { [weak self] (_) in
      self?.films = FilmManager.shared.films
      self?.reloadData()
    }
  }
  
  // MARK: Helpers
  
  fileprivate func setupDelegates() {
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  // MARK: - Views Setup
  
  fileprivate func setupVCViews() {
    tableViewSetup()
    setupSearchBar()
    setupNavigation()
  }
  
  fileprivate func tableViewSetup() {
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 170
    tableView.register(UINib(nibName: "FilmCell", bundle: nil), forCellReuseIdentifier: "filmCell")
  }
  
  func setupNavigation() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search for a movie title or actor"
    searchController.hidesNavigationBarDuringPresentation = false
    navigationItem.searchController = searchController
    
    let titles = ["Distance", "Title", "Newest", "Oldest"]
    segmentedController = UISegmentedControl(items: titles)
    segmentedController.addTarget(self, action: #selector(handleSort), for: .allEvents)
    segmentedController.selectedSegmentIndex = 0
    segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    segmentedController.tintColor = .lightGray
    segmentedController.selectedSegmentTintColor = UIColor.black
    segmentedController.layer.borderWidth = 1
    navigationItem.titleView = segmentedController
  }
  
  @objc func handleSort(sender: AnyObject) {
    let index = segmentedController.selectedSegmentIndex
    let type = FilmSort.allCases[index]
    films = FilmManager.shared.sortFilms(by: type)
    reloadData()
  }
  
  func filterContentForSearchText(_ searchText: String) {
    filteredFilms = films.filter { (film: Film) -> Bool in
      return film.title.lowercased().contains(searchText.lowercased()) || film.actorsString.lowercased().contains(searchText.lowercased())
    }
    reloadData()
  }
  
  func reloadData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
      self.tableView.refreshControl?.endRefreshing()
    }
  }
  
  func updateImage(tableView: UITableView, cell: FilmCell, indexPath: IndexPath) {
    let displayedFilms = isFiltering ? filteredFilms : films
    guard displayedFilms.indices.contains(indexPath.row) else {
      return
    }
    let film = displayedFilms[indexPath.row]
    if let filmImage = FilmManager.shared.imdbFilmsDict[film.title]?.poster, let imageUrl = URL(string: filmImage) {
      ImageCache.shared.image(url: imageUrl) { (image) in
        if cell.film?.title == film.title, let image = image {
          DispatchQueue.main.async {
            cell.setImage(image)
          }
        }
      }
    } else if let image = UIImage.defaultImageIcon {
      DispatchQueue.main.async {
        cell.setImage(image)
      }
      print("error loading image for \(film.title)")
    }
  }
}

// MARK: - UITableView dataSource and delegate

extension FilmsListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredFilms.count : films.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell") as? FilmCell else { return UITableViewCell() }
    let film = isFiltering ? filteredFilms[indexPath.row] : films[indexPath.row]
    cell.clearImage()
    if let details = FilmManager.shared.imdbFilmsDict[film.title] {
      cell.filmDetails = details
    }
    cell.configure(film, index: indexPath)
    self.updateImage(tableView: tableView, cell: cell, indexPath: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? FilmCell else { return }
    tableView.deselectRow(at: indexPath, animated: false)
    let film = isFiltering ? filteredFilms[indexPath.row] : films[indexPath.row]
    if let filmDetailVC = UIStoryboard(name: "Films", bundle: nil).instantiateViewController(withIdentifier: "FilmDetailsCollectionViewController") as? FilmDetailsCollectionViewController {
      filmDetailVC.film = film
      filmDetailVC.image = cell.posterImage ?? .defaultImageIcon
      
      if let details = FilmManager.shared.imdbFilmsDict[film.title] {
        filmDetailVC.filmDetails = details
      }
      self.navigationController?.pushViewController(filmDetailVC, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 170
  }
  
}

extension FilmsListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    searchController.searchBar.showsBookmarkButton = !searchController.isActive
    if let text = searchBar.text {
      filterContentForSearchText(text)
    }
  }
  
}

