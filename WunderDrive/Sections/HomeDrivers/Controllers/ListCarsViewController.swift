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
        tableView.estimatedRowHeight = 150
        
        // For Lazy paging loading
        tableView.rx.contentOffset
            .flatMap { offset in
                self.tableView.isNearBottomEdge() ? Observable.just(()) : Observable.empty()
            }
            .debounce(0.1, scheduler: MainScheduler.instance)
            .bind(to: homeDriversViewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
    }
    
    func setupViewModel() {
        homeDriversViewModel.setupHomeDriversViewModel()
        
        // --- For loading animation ---
        homeDriversViewModel.isLoadingAnimation.subscribe(onNext: { [weak self] (isLoading) in
            if isLoading { self?.loadingView.startLoadding() }
            else {  self?.loadingView.stopLoadding() }
        }).disposed(by: disposeBag)
        
        // --- For handling error ---
        homeDriversViewModel.errorObservable.subscribe(onNext: { (error) in
            Helper.showAlertViewWith(error: error)
        }).disposed(by: disposeBag)
        
        // --- Binding for TableView ---
        homeDriversViewModel.elements.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (results) in
                guard let strongSelf = self else { return }
                strongSelf.tableView.dataSource = nil
                strongSelf.tableView.delegate = nil
                Observable.just(results)
                    .bind(to: strongSelf.tableView.rx
                        .items(cellIdentifier: "DriverInformationCell")) { (index, model: Driver, cell) in
                            if let cell: DriverInformationCell = cell as? DriverInformationCell {
                                cell.setupCellWithModel(model: model, index: index)
                            }
                    }.disposed(by: strongSelf.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    
}
