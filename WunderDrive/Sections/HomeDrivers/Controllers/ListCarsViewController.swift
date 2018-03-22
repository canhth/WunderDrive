//
//  ListCarsViewController.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit 

final class ListCarsViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    fileprivate var viewModel = ListCarsViewModel(homeSearchService: SearchDriversServiece())
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
     
    //MARK: - Setup views & ViewModel
    
    /// Setup all the view components
    fileprivate func setupViews() {
        
        // TableView
        tableView.registerCellNib(DriverInformationCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.dataSource = self
        tableView.delegate = self
    
    }
    
    func setupViewModel() {
        viewModel.listViewDelegate = self
    }
    
}

extension ListCarsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverInformationCell", for: indexPath) as! DriverInformationCell
        if let model = viewModel.itemAtIndex(indexPath.row) {
            cell.setupCellWithModel(model: model)
        }
        return cell
    }
}

extension ListCarsViewController: UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.tableView.isNearBottomEdge()  {
            viewModel.loadDataOfNextPage()
        }
    }
}

extension ListCarsViewController: HomeListViewModelViewDelegate {
    
    func listCarsDidChanged() {
        self.tableView.reloadData()
    }
}

// Default tabbar for HomeView
class MainTabbarViewController: UITabBarController { }
