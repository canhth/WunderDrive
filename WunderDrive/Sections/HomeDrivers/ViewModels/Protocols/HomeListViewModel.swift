//
//  HomeViewModel.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 22/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

protocol HomeListViewModelViewDelegate {
    func listCarsDidChanged()
}

protocol HomeListViewModel
{
    var listViewDelegate: HomeListViewModelViewDelegate? { get set }
    
    var numberOfItems: Int { get }
    func itemAtIndex(_ index: Int) -> Car?
    
}
