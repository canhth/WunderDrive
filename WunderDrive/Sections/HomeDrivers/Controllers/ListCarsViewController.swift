//
//  ListCarsViewController.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import RxCocoa
import RxSwift

final class ListCarsViewController: UIViewController {

    // MARK: - IBOutlets & Variables
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let homeDriversViewModel = ListCarsViewModel(homeSearchService: SearchDriversServiece())
    
    fileprivate lazy var loadingView: LoaddingView = {
        let loadingView = LoaddingView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = .clear
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(loadingView)
        return loadingView
    }()
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }
    
    //MARK: - Setup views & ViewModel
    
    /// Setup all the view components
    fileprivate func setupViews() {
        
        // TableView
        tableView.registerCellNib(DriverInformationCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = self.view.bounds.width
        
        // For Lazy paging loading
        tableView.rx.contentOffset
            .flatMap { offset in
                self.tableView.isNearBottomEdge() ? Observable.just(()) : Observable.empty()
            }
            .bind(to: homeDriversViewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
    }
    
    func setupViewModel() {
        homeDriversViewModel.setupHomeDriversViewModel()
    }
    

}
