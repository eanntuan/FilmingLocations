//
//  UICollectionViewExtension.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation
import UIKit

/// UICollectionView Extensions so that registering a nib/class and
/// dequeue'n those cells can be done with the type, instead of a string identifier.

extension UICollectionView {

    func register<T: UICollectionViewCell>(_: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadedView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerHeader<T: UICollectionReusableView>(_: T.Type) {
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.defaultReuseIdentifier)
    }

    // Adding header methods cuz our timeline needs em.

    func dequeueResusableHeader<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T {
        guard let header = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            // TODO: Our own custom error
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return header
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            // TODO: Our own custom error
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
