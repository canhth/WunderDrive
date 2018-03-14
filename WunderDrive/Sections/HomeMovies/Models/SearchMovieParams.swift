//
//  SearchMovieParams.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 7/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation


/// An Parameter object for search API
struct SearchMovieParams: Codable {
    
    var api_key: String = "2696829a81b1b5827d515ff121700838"
    var query: String = "1"
    var page: Int = 1
    
    init(query: String, page: Int) {
        self.query = query
        self.page = page
    }
}
