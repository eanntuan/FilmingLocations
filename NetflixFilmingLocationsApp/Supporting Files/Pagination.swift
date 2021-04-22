//
//  Pagination.swift
//  NetflixFilmingLocationsApp
//
//  Created by Eann Tuan on 4/21/21.
//

import Foundation

struct Pagination {
    static var limit = 20
    static var offSet = 0
    
    static var nextPage: (offSet: Int, limit: Int) {
        offSet += limit
        return (offSet: offSet, limit: limit)
    }
    
    static var newPage: (offSet: Int, limit: Int) {
        offSet = 0
        return (offSet: offSet, limit: limit)
    }
    
}
