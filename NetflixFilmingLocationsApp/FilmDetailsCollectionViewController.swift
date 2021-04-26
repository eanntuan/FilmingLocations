//
//  FilmDetailsCollectionViewController.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation
import UIKit

class FilmDetailsCollectionViewController: UICollectionViewController {
  
  static let sectionHeaderElementKind = "section-header-element-kind"
  
  enum Section: String, CaseIterable {
    case title
    case plot = "Plot"
    case map
    case locations = "Find other locations:"
  }
  
  // MARK: - Properties
  
  private var sections = Section.allCases
  private lazy var dataSource = makeDataSource()
  var film: Film!
  var filmDetails: ImdbFilm?
  var image: UIImage!
  
  var otherLocations: [Film] {
    if let locations = FilmManager.shared.filmsDict[film.title] {
      return locations.filter( {$0.locations != self.film.locations })
    } else {
      return []
    }
  }
  
  // MARK: - Value Types
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, FilmDetailItem>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FilmDetailItem>
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
  }
  
  func configureCollectionView() {
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.delegate = self
    collectionView.register(FilmDetailsHeaderCell.self)
    collectionView.register(FilmLocationMapCell.self)
    collectionView.register(PlotCell.self)
    collectionView.register(LocationCell.self)
    collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: FilmDetailsCollectionViewController.sectionHeaderElementKind, withReuseIdentifier: DetailHeaderView.reuseIdentifier)
    collectionView.collectionViewLayout = generateLayout()
    applySnapshot(animatingDifferences: false)
    collectionView.largeContentTitle = film.title
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
  
  // MARK: - Functions
  
  func makeDataSource() -> DataSource {
    
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: { (collectionView, indexPath, _ ) ->
        UICollectionViewCell? in
        let sectionType = Section.allCases[indexPath.section]
        switch sectionType {
        case .title:
          let cell: FilmDetailsHeaderCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
          cell.configure(self.film, filmDetails: self.filmDetails, image: self.image)
          cell.setNeedsLayout()
          return cell
        case .plot:
          let cell: PlotCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
          cell.configure(for: self.film, details: self.filmDetails)
          cell.setNeedsLayout()
          return cell
        case .map:
          let cell: FilmLocationMapCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
          cell.configure(self.film)
          cell.setNeedsLayout()
          return cell
        case .locations:
          let cell: LocationCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
          if self.otherLocations.indices.contains(indexPath.row) {
            let item = self.otherLocations[indexPath.row]
            cell.configure(item)
          }
          return cell
        }
      })
    
    dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
      guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: DetailHeaderView.reuseIdentifier,
              for: indexPath) as? DetailHeaderView else { return UICollectionReusableView() }
      supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
      supplementaryView.configure()
      return supplementaryView
    }
    return dataSource
  }
  
  func applySnapshot(animatingDifferences: Bool = true) {
    let snapshot = snapshotForCurrentState()
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, FilmDetailItem> {
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, FilmDetailItem>()
    snapshot.appendSections(Section.allCases)
    
    if let film = film {
      snapshot.appendItems([FilmDetailItem(film, film.title)], toSection: .title)
    }
    if let plot = filmDetails?.plot, !plot.isEmpty {
      let plotItem = FilmDetailItem(film, plot)
      snapshot.appendItems([plotItem], toSection: .plot)
    }
    snapshot.appendItems([FilmDetailItem(film)], toSection: .map)
    
    if !otherLocations.isEmpty {
      let locationItems = itemsForFilmLocations(otherLocations)
      snapshot.appendItems(locationItems, toSection: .locations)
    }
  
    return snapshot
  }
  
  func itemsForFilmLocations(_ otherLocations: [Film]) -> [FilmDetailItem] {
    var items: [FilmDetailItem] = []
    for film in otherLocations {
      let filmItem = FilmDetailItem(film)
      if !items.contains(filmItem) {
        items.append(filmItem)
      }
    }
    return items
  }
  
  func generateLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
      -> NSCollectionLayoutSection? in
      let sectionLayoutKind = Section.allCases[sectionIndex]
      switch sectionLayoutKind {
      case .locations:
        return self?.generateLocationsLayout()
      default:
        return self?.generateLayout(for: sectionLayoutKind)
      }
    }
    return layout
  }
  
  func generateLocationsLayout() -> NSCollectionLayoutSection {
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let shopItem = NSCollectionLayoutItem(layoutSize: itemSize)
    
    shopItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: shopItem, count: 1)
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)

    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(44))
    
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: FilmDetailsCollectionViewController.sectionHeaderElementKind,
      alignment: .top)
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = [sectionHeader]
    return section
  }
  
  func generateLayout(for section: Section) -> NSCollectionLayoutSection {
    
    var height = CGFloat(240)
    switch section {
    case .title:
      height = CGFloat(170)
    case .plot:
      height = CGFloat(85)
    case .map:
      if let facts = film.funFacts, !facts.isEmpty {
        height = 300
      }
    default:
      break
    }
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let banner = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: banner, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
}
