//
//  FilmManager.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/20/21.
//

import Foundation
import CoreLocation

enum FilmSort: String, CaseIterable {
  case title
  case newest
  case oldest
  case distance
  case director
  case company
}

class FilmManager: NSObject, CLLocationManagerDelegate {
  
  static let shared = FilmManager()
  var newFilms: [Film] = []
  var cachedFilms: [Film] = []
  var cachedImdbFilms: [ImdbFilm] = []
  var locationManager = CLLocationManager()
  var imdbFilmsDict: [String: ImdbFilm] = [:]
  var filmsDict: [String: [Film]] = [:]
  var distinctFilms: [Film] = []
  
  var films: [Film] {
    return distinctFilms.isEmpty ? cachedFilms : distinctFilms
  }

  lazy var filmsFilePath: String = {
    let documents = FileManager.documentsDirectory
    return documents.appendingPathComponent("films").path
  }()
  
  lazy var imdbFilmsFilePath: String = {
    let documents = FileManager.documentsDirectory
    return documents.appendingPathComponent("imdb_films").path
  }()
  
  lazy var filmTitlesFilePath: String = {
    let documents = FileManager.documentsDirectory
    return documents.appendingPathComponent("films_title_dict").path
  }()
  
  func setup() {
    setupLocationManager()
    getFilms()
  }
  
  func getFilms() {
    readFilmsFromFilepath { result in
      if let result = result {
        self.cachedFilms = result
      }
    }
    WebService().getFilms { films, error  in
      if let films = films {
        self.newFilms = films
        self.getFilmTitleDict()
        self.getDistinctFilms()
        DispatchQueue.global(qos: .background).async {
          self.writeFilmsToFilePath(films)
          self.getFilmDetails()
        }
      }
    }
  }
  
  func getDistinctFilms() {
    for (_, value) in filmsDict {
      if let film = value.first {
        self.distinctFilms.append(film)
      }
    }
    self.distinctFilms = sortFilms(by: .distance)
  }
  
  func getFilmTitleDict() {
    if filmsDict.isEmpty {
      readFilmTitleDictFilePath { result in
        if let result = result {
          filmsDict = result.filmTitleDict
        } else {
          makeFilmDict()
        }
      }
    }
  }
  
  func makeFilmDict() {
    for film in films {
      if var val = filmsDict[film.title] {
        if !val.contains(film) {
          val.append(film)
          filmsDict[film.title] = val.sorted {$0.distanceToCurrentLocation < $1.distanceToCurrentLocation }
        }
      } else {
        filmsDict[film.title] = [film]
      }
    }
    writeFilmTitleDictFilePath(filmsDict)
  }
  
  func getFilmDetails() {
    var imdbFilms: [ImdbFilm] = []
    readImdbFilmsFromFilepath { result in
      if let result = result {
        imdbFilms = result
      }
    }

    for film in self.distinctFilms {
      if let cachedFilm = cachedImdbFilms.filter( {$0.title == film.title} ).first {
        self.imdbFilmsDict[film.title] = cachedFilm
        if !imdbFilms.contains(cachedFilm) {
          imdbFilms.append(cachedFilm)
        }
      } else {
        let params = ["t": "\(film.title)", "apikey": "\(WebService.apiKey)"]
        guard let url = URL(string: WebService.movieInfoUrl) else { return }
        WebService.get(params, url: url) { data,error  in
          guard let data = data, error == nil else { return }
          do {
            let result = try JSONDecoder.defaultDecoder.decode(ImdbFilm.self, from: data)
            self.imdbFilmsDict[film.title] = result
            if !imdbFilms.contains(result) {
              imdbFilms.append(result)
            }
          } catch {
            print("\(#function): \(error)")
          }
        }
      }
    }
    writeImdbFilmsToFilePath(imdbFilms)
  }
  
  func sortFilms(by type: FilmSort) -> [Film] {
    switch type {
    case .title:
      return films.sorted(by: { $0.title < $1.title })
    case .director:
      return films.sorted(by: { $0.director > $1.director })
    case .newest:
      return films.sorted(by: { $0.releaseYear > $1.releaseYear })
    case .oldest:
      return films.sorted(by: { $0.releaseYear < $1.releaseYear })
    case .company:
      return films.sorted(by: { $0.productionCompany > $1.productionCompany })
    case .distance:
      return films.sorted(by: { $0.distanceToCurrentLocation < $1.distanceToCurrentLocation })
    }
  }
  
  func setupLocationManager() {
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
  }
  
  // FIXME
  func writeImdbFilmsToFilePath(_ films: [ImdbFilm]) {
      do {
          let data = try JSONEncoder.defaultEncoder.encode(films)
          if FileManager.default.fileExists(atPath: imdbFilmsFilePath) {
              try FileManager.default.removeItem(atPath: imdbFilmsFilePath)
          }
          try (data as NSData).write(toFile: imdbFilmsFilePath, options: .atomic)
      } catch {
          print("\(#function): \(error)")
      }
  }
  
  func readImdbFilmsFromFilepath(_ completion: ([ImdbFilm]?) -> Void) {
    if let data = NSData(contentsOfFile: imdbFilmsFilePath) {
      do {
        let cache = try JSONDecoder.defaultDecoder.decode([ImdbFilm].self, from: data as Data)
        completion(cache)
      } catch {
        print("\(#function): \(error)")
        completion(nil)
      }
    }
  }
  
  func writeFilmsToFilePath(_ films: [Film]) {
      do {
          let data = try JSONEncoder.defaultEncoder.encode(films)
          if FileManager.default.fileExists(atPath: filmsFilePath) {
              try FileManager.default.removeItem(atPath: filmsFilePath)
          }
          try (data as NSData).write(toFile: filmsFilePath, options: .atomic)
      } catch {
          print("\(#function): \(error)")
      }
  }
  
  func readFilmsFromFilepath(_ completion: ([Film]?) -> Void) {
    if let data = NSData(contentsOfFile: filmsFilePath) {
      do {
        let cache = try JSONDecoder.defaultDecoder.decode([Film].self, from: data as Data)
        completion(cache)
      } catch {
        print("\(#function): \(error)")
        completion(nil)
      }
    }
  }
  
  func writeFilmTitleDictFilePath(_ filmTitleDict: [String: [Film]]) {
    var cache = FilmTitleToLocationsCache()
    cache.filmTitleDict = filmTitleDict
      do {
          let data = try JSONEncoder.defaultEncoder.encode(cache)
          if FileManager.default.fileExists(atPath: filmTitlesFilePath) {
              try FileManager.default.removeItem(atPath: filmTitlesFilePath)
          }
          try (data as NSData).write(toFile: filmTitlesFilePath, options: .atomic)
      } catch {
          print("\(#function): \(error)")
      }
  }
  
  func readFilmTitleDictFilePath(_ completion: (FilmTitleToLocationsCache?) -> Void) {
    if let data = NSData(contentsOfFile: filmTitlesFilePath) {
      do {
        let cache = try JSONDecoder.defaultDecoder.decode(FilmTitleToLocationsCache.self, from: data as Data)
        completion(cache)
      } catch {
        print("\(#function): \(error)")
        completion(nil)
      }
    } else {
      completion(nil)
    }
  }
  
//  func getMoreMovieInfo(for title: String, _ completion: @escaping (ImdbFilm?) -> Void) {
//    guard let url = URL(string: "\(WebService.movieInfoUrl)") else { return }
//    WebService.get(title, url: url) { data, error in
//      guard let data = data else { return }
//      do {
//        let responseData = try JSONDecoder().decode(ImdbFilm.self, from: data)
//        print("SUCCESS getting movie info for: \(title)")
//        completion(responseData)
//      } catch {
//        completion(nil)
//        print("error getting movie info for: \(title)")
//      }
//    }
//  }

}
