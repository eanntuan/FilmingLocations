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
  
  let searchController = UISearchController(searchResultsController: nil)
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  var segmentedController: UISegmentedControl!
  //  var businessContainerVC: BusinessesContainerVC?
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVCViews()
    setupDelegates()
    films = FilmManager.shared.films
    if films.isEmpty {
      getLatestFilms()
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
    addFooterView()
    footerViewSetup()
    setupSearchBar()
    setupNavigation()
  }
  
  fileprivate func tableViewSetup() {
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    tableView.register(UINib(nibName: "FilmCell", bundle: nil), forCellReuseIdentifier: "filmCell")
  }
  
  func setupNavigation() {
    
  }
  
  /// Footer view for activity indicator (infinite scrolling)
  fileprivate func addFooterView() {
    footerActivityIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    activityIndicatorView.center = footerActivityIndicatorView.center
    activityIndicatorView.startAnimating()
    footerActivityIndicatorView.addSubview(activityIndicatorView)
    tableView.tableFooterView = footerActivityIndicatorView
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
    navigationItem.titleView = segmentedController
  }
  
  @objc func handleSort(sender: AnyObject) {
    let index = segmentedController.selectedSegmentIndex
    let type = FilmSort.allCases[index]
    films = FilmManager.shared.sortFilms(by: type)
    reloadData()
  }
  
  private func getLatestFilms() {
    WebService().getFilms { response, error in
      if let films = response {
        self.films = films
        self.reloadData()
      }
    }
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
        if cell.film?.title == film.title {
          DispatchQueue.main.async {
            cell.imageView?.image = nil
            cell.imageView?.image = image ?? nil
          }
        }
      }
    } else {
      print("error loading image for \(film.title)")
    }
  }
}

// MARK: - Infinite scrolling

extension FilmsListViewController: UIScrollViewDelegate {
  
  fileprivate func footerViewSetup() {
    if tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.height - 55 && tableView.isDragging {
      footerActivityIndicatorView.isHidden = false
    } else {
      footerActivityIndicatorView.isHidden = true
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    footerViewSetup()
    guard !isDownloadingMoreData else { return }
    if scrollView.contentOffset.y > scrollView.contentSize.height - tableView.bounds.height && tableView.isDragging {
      isDownloadingMoreData = true
      //            self.businessContainerVC?.performMoreSearch()
    }
  }
}

// MARK: - UITableView dataSource and delegate

extension FilmsListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableView.tableFooterView?.isHidden = !(films.count > 0)
    footerViewSetup()
    return isFiltering ? filteredFilms.count : films.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell") as? FilmCell else { return UITableViewCell() }
    let film = isFiltering ? filteredFilms[indexPath.row] : films[indexPath.row]
    cell.configure(film, index: indexPath)
    self.updateImage(tableView: tableView, cell: cell, indexPath: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    let film = isFiltering ? filteredFilms[indexPath.row] : films[indexPath.row]
    if let filmDetailVC = UIStoryboard(name: "Films", bundle: nil).instantiateViewController(withIdentifier: "FilmDetailsViewController") as? FilmDetailsViewController {
      filmDetailVC.film = film
      self.navigationController?.pushViewController(filmDetailVC, animated: true)
    }
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

