//
//  NibLoadedView.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/24/21.
//

import Foundation
import UIKit

protocol NibLoadedView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadedView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

// Adding to NibLoadedView so it can be instantiated with a frame.

extension NibLoadedView where Self: UIView {

    static func fromNib(with frame: CGRect) -> Self {
        let bundle = Bundle(for: self)
        guard let nib = bundle.loadNibNamed(nibName, owner: self, options: nil),
            let view = nib.first as? Self else {
                fatalError()
        }
        view.frame = frame
        return view
    }
}
