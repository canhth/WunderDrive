//
//  HomeMoviesViewController.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 7/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class HomeMoviesViewController: BaseMainViewController {

    //MARK: - IBOutlets & Variables
    @IBOutlet weak fileprivate var tableView: UITableView!
    @IBOutlet weak fileprivate var tableHeaderView: UIView!
    @IBOutlet weak fileprivate var careemSearchBar: CareemSearchBar!
    @IBOutlet weak fileprivate var resultsLabel: UILabel!
    @IBOutlet weak fileprivate var containerView: UIView!
    
    fileprivate var careemSearchController: CareemSearchViewController!
    fileprivate let disposeBag = DisposeBag()
    fileprivate let homeMoviesViewModel = HomeMoviesViewModel(homeSearchService: HomeMoviesService())
    
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
        setupSearchSuggestionController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() 
        tableView.setupHeightHeaderTableViewAutomaticly()
    }

    //MARK: - Setup views & ViewModel
    
    /// Setup all the view components
    fileprivate func setupViews() {
        
        careemSearchController = CareemSearchViewController(searchResultsController: self, searchBar: careemSearchBar)
        setupSuggestionsList(forBeginSearch: false)
        
        // TableView
        tableView.registerCellNib(MovieCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = self.view.bounds.width
        
        // Dismiss keyboard when scroll
        tableView.rx.contentOffset
            .subscribe { _ in
                if self.careemSearchBar.isFirstResponder {
                    self.careemSearchBar.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
        
        // For Lazy paging loading
        tableView.rx.contentOffset
            .flatMap { offset in
                self.tableView.isNearBottomEdge() ? Observable.just(()) : Observable.empty()
            }
            .bind(to: homeMoviesViewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupSearchSuggestionController() {
        if let suggestionsViewController = self.childViewControllers.first as? SearchSuggestionsViewController {
            suggestionsViewController.homeMoviesViewModel = self.homeMoviesViewModel
            suggestionsViewController.setupSuggestionViewModel()
        }
    }
    
    fileprivate func setupViewModel() {
        homeMoviesViewModel.setupHomeMovieViewModel()
        homeMoviesViewModel.setupViewModelForSuggestion(searchTextField: careemSearchBar.rx)
        
        // --- For list suggestions ---
        homeMoviesViewModel.suggestionsObservable.subscribe(onNext: { [weak self] (suggestions) in
            self?.setupSuggestionsList(forBeginSearch: suggestions.count > 0)
        }).disposed(by: disposeBag)
        
        // --- For loading animation ---
        homeMoviesViewModel.isLoadingAnimation.subscribe(onNext: { [weak self] (isLoading) in
            if isLoading { self?.loadingView.startLoadding() }
            else {  self?.loadingView.stopLoadding() }
        }).disposed(by: disposeBag)
        
        // --- For handling error ---
        homeMoviesViewModel.errorObservable.subscribe(onNext: { (error) in
            Helper.showAlertViewWith(error: error)
        }).disposed(by: disposeBag)
        
        // --- For binding query string ---
        homeMoviesViewModel.queryString
            .subscribe(onNext: { [weak self] (query) in
                self?.careemSearchBar.text = query
                self?.setupSuggestionsList(forBeginSearch: false)
            }).disposed(by: disposeBag)
        
        // --- For setup result overview infor ---
        homeMoviesViewModel.moviesResultObservable.subscribe(onNext: { [weak self] (results) in
            self?.setupLabelResults(keyword: self?.careemSearchBar.text ?? "", results: results?.totaResults.description ?? "0")
        }).disposed(by: disposeBag)
        
        // --- Binding for TableView ---
        homeMoviesViewModel.elements.asObservable()
            .subscribe(onNext: { [weak self] (results) in
                guard let strongSelf = self else { return }
                strongSelf.tableView.dataSource = nil
                strongSelf.tableView.delegate = nil
                
                Observable.just(results)
                    .bind(to: strongSelf.tableView.rx
                                                .items(cellIdentifier: "MovieCell")) { (index, model: Movie, cell) in
                                                    if let cell: MovieCell = cell as? MovieCell {
                                                        cell.setupMovieCellWithModel(model: model)
                                                    }
                    }.disposed(by: strongSelf.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    
    /// Set up the Search Suggestion list view
    ///
    /// - Parameter forBeginSearch: is editing or not
    fileprivate func setupSuggestionsList(forBeginSearch: Bool) {
        if !forBeginSearch { self.view.endEditing(true) }
        self.containerView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.containerView.alpha = forBeginSearch ? 1 : 0
        }) { (_) in
            self.containerView.isHidden = !forBeginSearch
        }
    }
    
    
    /// Set the label results when results has found
    ///
    /// - Parameters:
    ///   - keyword: query string
    ///   - results: total results
    fileprivate func setupLabelResults(keyword: String, results: String) {
        resultsLabel.text = "Found \(results) results by '\(keyword)'"
    }
    
}

// MARK: CareemSearchControllerDelegate
extension HomeMoviesViewController: CareemSearchControllerDelegate {
    
    func didTapOnSearchButton() {
        self.setupSuggestionsList(forBeginSearch: false)
        if let query = careemSearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            self.homeMoviesViewModel.queryString.onNext(query)
        }
    }
    
    func didTapOnCancelButton() {
        self.setupSuggestionsList(forBeginSearch: false)
    }
}


