//
//  FilmItem.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation

class FilmDetailItem: Equatable, Hashable {
  let film: Film?
  let location: String?
  let filmDetails: ImdbFilm?
  let plot: String?
  let title: String?
  
  init(_ film: Film, _ title: String) {
    self.film = film
    self.location = film.locations
    self.filmDetails = nil
    self.title = title
    self.plot = ""
  }
  
  init(_ film: Film) {
    self.film = film
    self.location = film.locations
    self.filmDetails = nil
    self.plot = ""
    self.title = film.title
  }
  
  init(_ film: Film, _ filmDetails: ImdbFilm?) {
    self.film = film
    self.location = film.locations
    self.filmDetails = filmDetails
    self.plot = self.filmDetails?.plot
    self.title = film.title
  }
  
  init(_ film: Film, _ plot: String?) {
    self.film = film
    self.location = film.locations
    self.filmDetails = nil
    self.plot = plot
    self.title = film.title
  }
  
  func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
  }
  
  static func == (lhs: FilmDetailItem, rhs: FilmDetailItem) -> Bool {
    return lhs.location == rhs.location
  }
  
  private let identifier = UUID()
}
