//
//  SearchSuggestionsViewController.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 8/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchSuggestionsViewController: BaseMainViewController {

    //MARK: IBOutlets & Variables
    @IBOutlet weak var tableView: UITableView!
    var homeMoviesViewModel : HomeMoviesViewModel!
    
    fileprivate let disposeBag = DisposeBag()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
  
    //MARK: - Setup
    fileprivate func setupViews() {
        tableView.registerCellNib(SuggestionCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = self.view.bounds.width
        tableView.accessibilityIdentifier = "SuggestionsTableView"
    }
    
    func setupSuggestionViewModel() {
        // Binding for TableView
        homeMoviesViewModel.suggestionsObservable
            .subscribe(onNext: { [weak self] (results) in
                guard let strongSelf = self else { return }
                strongSelf.tableView.dataSource = nil
                strongSelf.tableView.delegate = nil
                
                Observable.just(results)
                    .bind(to: strongSelf.tableView.rx
                                            .items(cellIdentifier: "SuggestionCell")) { (index, model: Suggestion, cell) in
                                                if let cell: SuggestionCell = cell as? SuggestionCell {
                                                    cell.setupCellWithSuggestion(model: model)
                                                }
                    }.disposed(by: strongSelf.disposeBag)
            }).disposed(by: disposeBag)
        
        // Selected item TableView
        tableView.rx.modelSelected(Suggestion.self)
            .subscribe(onNext: { [weak self] model in
                guard let strongSelf = self else { return }
                strongSelf.homeMoviesViewModel.queryString.onNext(model.name)
            }).disposed(by: disposeBag)
    }
    
}
