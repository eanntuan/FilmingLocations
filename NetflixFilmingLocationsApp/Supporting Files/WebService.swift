//
//  WebService.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation
import UIKit

class WebService {
  
  /// base URL for API calls to Netflix, IMDB
  static let baseUrlString: String = "http://assets.nflxext.com/ffe/siteui/iosui/filmData.json"
  static let movieInfoUrl: String = "http://www.omdbapi.com/?apikey=6ff8ac9e"
  static let apiKey: String = "6ff8ac9e"

  static func get(_ params: [String: String]?, url: URL, _ completion: @escaping (Data?, Error?) -> Void) {
    var component = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    
    if let params = params {
      component.queryItems = params.compactMap { return URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
    
    var request = URLRequest(url: component.url!)
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard let data = data, error == nil else {
        completion(nil, error)
        return
      }
      completion(data, nil)
    }
    task.resume()
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
}
