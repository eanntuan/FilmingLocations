//
//  FilmItem.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation

class FilmLocationItem: Equatable, Hashable {
  let film: Film?
  let location: String?
  
  init(_ film: Film) {
    self.film = film
    self.location = film.locations
  }
  
  func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
  }
  
  static func == (lhs: FilmLocationItem, rhs: FilmLocationItem) -> Bool {
    return lhs.location == rhs.location
  }
  
  private let identifier = UUID()
}
