//
//  ImdbFilm.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/22/21.
//

import Foundation

struct ImdbFilm: Codable, Equatable {
  
  var title: String
//  var year: String
//  var rated: String?
//  var released: String?
  var genre: String?
//  var director: String?
//  var writer: String?
//  var actors: String?
//  var plot: String?
//  var language: String?
//  var country: String?
//  var awards: String?
  var poster: String?
//  var ratings: [Rating]?
  var imdbID: String?
  var imdbRating: String?
//  var metascore: String?
//  var type: String?
//  var boxOffice: String?
  
  enum CodingKeys: String, CodingKey {
    case title = "Title"
    case poster = "Poster"
    case imdbRating
    case imdbID
    case genre = "Genre"
  }

  init() {
    self.title = ""
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    poster = try container.decode(String.self, forKey: .poster)
    imdbRating = try container.decode(String.self, forKey: .imdbRating)
    imdbID = try container.decode(String.self, forKey: .imdbID)
    genre = try container.decode(String.self, forKey: .genre)
  }

  static func == (lhs: ImdbFilm, rhs: ImdbFilm) -> Bool {
    return lhs.title == rhs.title
  }

}

struct Rating: Codable {
  var source: String?
  var value: String?
}
