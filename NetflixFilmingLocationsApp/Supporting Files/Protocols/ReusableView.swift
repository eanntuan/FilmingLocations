//
//  ReusableView.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation
import UIKit

/**
 This protocol is used by the `UICollectionView` and `UITableView` extensions.
 */

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

//extension UICollectionViewCell: ReusableView {}
extension UICollectionReusableView: ReusableView {}
extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
