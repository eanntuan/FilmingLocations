//
//  ImdbFilm.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/22/21.
//

import Foundation

struct ImdbFilm: Codable, Equatable {
  
  var title: String
  var genre: String?
  var plot: String?
  var poster: String?
  var imdbID: String?
  var imdbRating: String?
  
  enum CodingKeys: String, CodingKey {
    case title = "Title"
    case poster = "Poster"
    case imdbRating
    case imdbID
    case genre = "Genre"
    case plot = "Plot"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    poster = try container.decode(String.self, forKey: .poster)
    imdbRating = try container.decode(String.self, forKey: .imdbRating)
    imdbID = try container.decode(String.self, forKey: .imdbID)
    genre = try container.decode(String.self, forKey: .genre)
    plot = try container.decode(String.self, forKey: .plot)
  }

  static func == (lhs: ImdbFilm, rhs: ImdbFilm) -> Bool {
    return lhs.title == rhs.title
  }

}

struct Rating: Codable {
  var source: String?
  var value: String?
}
