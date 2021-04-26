//
//  DetailHeaderView.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/25/21.
//

import Foundation
import UIKit

class DetailHeaderView: UICollectionReusableView, NibLoadedView {
  
  static let reuseIdentifier = "header-reuse-identifier"
  
  let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure() {
    backgroundColor = .black
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.textColor = .white
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
      label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
    ])
    label.font = .boldSystemFont(ofSize: 16)
  }
}
