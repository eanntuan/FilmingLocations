//
//  WebService.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation
import UIKit

class WebService {
  
  /// base URL for all calls to Netflix
  static let baseUrlString: String = "http://assets.nflxext.com/ffe/siteui/iosui/filmData.json"
  static let movieInfoUrl: String = "http://www.omdbapi.com/?apikey=dec26f2a"
  static let apiKey: String = "dec26f2a"
  
  func getFilmImage( _ completion: @escaping (String?) -> Void) {
    //    let endpoint = Router.getStoreBundle(id: id).url
    //    let tempKey = Configuration.apiKey.value
    //    let tempHeaders = ["x-api-key": tempKey]
    //    let request = HTTP.get(endpoint, parameters: nil, headers: tempHeaders)
    //    request.start { (response) in
  }
  
  func getFilms(completion: @escaping ([Film]?, Error?) -> Void) {
    
    let stockUrl = Self.baseUrlString
    
    guard let url = URL(string: stockUrl) else {
      fatalError("URL is not correct!")
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else {
        completion(nil, error)
        return
      }
      do {
        let response = try JSONDecoder.defaultDecoder.decode([FilmLocation].self, from: data)
        completion(response, nil)
      } catch {
        print("\(#function): \(error)")
        completion(nil, error)
      }
      
    }.resume()
  }
  
  static func get(_ params: [String: String]?, url: URL, _ completion: @escaping (Data?, Error?) -> Void) {
    var component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    
    if let params = params {
      component.queryItems = params.compactMap { return URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
    
    var request = URLRequest(url: component.url!)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let data = data else {
        completion(nil, error)
        return
      }
      completion(data, nil)
    }
    task.resume()
  }
    
//  static func get(_ title: String, _ completion: @escaping (ImdbFilm?, Error?) -> Void) {
//    let urlString = self.movieInfoUrl + "&t=\(title)"
//    guard let url = URL(string: urlString) else { return }
//    URLSession.shared.dataTask(with: url) { data, response, error in
//      guard let data = data, error == nil else {
//        completion(nil, error)
//        return
//      }
//      do {
//        let response = try JSONDecoder.defaultDecoder.decode(ImdbFilm.self, from: data)
//        completion(response, nil)
//      } catch {
//        print("\(#function): \(error)")
//        completion(nil, error)
//      }
//
//    }.resume()
//  }
  
  class func fetchImage(_ imageURL: URL?, _ completion: @escaping (UIImage?, Error?) -> Void)  {
    guard let imageURL = imageURL else {
//      completion(UIImage, Error)
      fatalError()
      return
    }
    WebService.get([:], url: imageURL) { data, error in
      if let error = error {
        completion(nil, error)
      }
      guard let data = data else {
        completion(nil, error)
        return
      }
      guard let image = UIImage(data: data) else {
        completion(nil, error)
        return
      }
      DispatchQueue.main.async {
        completion(image, nil)
      }
      
    }
  }
  
}
