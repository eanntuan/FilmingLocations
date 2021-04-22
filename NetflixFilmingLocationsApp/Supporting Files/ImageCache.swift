//
//  ImageCache.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/22/21.
//

import Foundation
import UIKit

class ImageCache: NSCache<NSString, UIImage> {
  
  static var shared = ImageCache()
  
  lazy var directory: URL = {
    let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return paths[0].appendingPathComponent("film_image_data")
  }()
  
  override init() {
    super.init()
    name = "ImageCache"
    countLimit = 50
    totalCostLimit = 50*1024*102
    do {
      try FileManager.default.createDirectory(atPath: directory.path,
                                              withIntermediateDirectories: true,
                                              attributes: nil)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func image(key: String) -> UIImage? {
    let sanitizedKey = key.sanitized()
    if let image = object(forKey: sanitizedKey as NSString) {
      return image
    }
    let filePath = directory.appendingPathComponent(sanitizedKey, isDirectory: false).appendingPathExtension("png").path
    guard let image = UIImage(contentsOfFile: filePath) else {
      return nil
    }
    setObject(image, forKey: sanitizedKey as NSString)
    return image
  }
  
  func cache(image: UIImage, key: String) {
    let sanitizedKey = key.sanitized()
    let url = directory.appendingPathComponent(sanitizedKey, isDirectory: false).appendingPathExtension("png")
    setObject(image, forKey: sanitizedKey as NSString)
    if FileManager.default.fileExists(atPath: url.absoluteString) {
      return
    }
    
    DispatchQueue.global(qos: .default).async {
      guard let png = image.pngData() else { return }
      do {
        try png.write(to: url)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  func image(url: URL, completion: @escaping (UIImage?) -> Void) {
    let key = url.absoluteString
    if let image = image(key: key) {
      completion(image)
      return
    }
    
    WebService.fetchImage(url) { (image, error) in
      if error != nil {
        print("error downloading image \(String(describing: url))")
        completion(nil)
      }
      guard let image = image else {
        completion(nil)
        return
      }
      self.cache(image: image, key: key)
      completion(image)
    }
  }
}

extension String {
  func sanitized() -> String {
    let invalidCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|")
      .union(.newlines)
      .union(.illegalCharacters)
      .union(.controlCharacters)
    
    return self
      .components(separatedBy: invalidCharacters)
      .joined(separator: "")
  }
}
