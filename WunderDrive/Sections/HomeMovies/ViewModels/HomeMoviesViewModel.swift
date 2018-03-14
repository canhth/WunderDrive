//
//  HomeMoviesViewModel.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 7/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CT_RESTAPI

/// Home search ViewModel, based on PaginationNetworkModel
final class HomeMoviesViewModel: PaginationNetworkModel<Movie> {
    
    //MARK: - Variables
    fileprivate(set) var moviesResultObservable     : Observable<MovieResults?>!
    fileprivate(set) var suggestionsObservable      : Observable<[Suggestion]>!
    fileprivate(set) var searchParam                : Variable<SearchMovieParams>!
    fileprivate(set) var homeSearchService          : SearchMovieService!
    fileprivate(set) var errorObservable            = PublishSubject<CTNetworkErrorType>()
    fileprivate(set) var isLoadingAnimation         = PublishSubject<Bool>()
    fileprivate(set) var queryString                = BehaviorSubject<String>(value: "2018")
    fileprivate(set) var page                       = BehaviorSubject<Int>(value: 1)
    fileprivate      let disposeBag                 = DisposeBag()
    
    
    //MARK: - Main functions
    
    /// Init ViewModel
    ///
    /// - Parameter homeSearchService: API service
    init(homeSearchService: SearchMovieService) {
        self.homeSearchService = homeSearchService
    }
    
    /// Setup View model by listening react of search bar field
    ///
    /// - Parameter searchTextField: searchBarField
    func setupHomeMovieViewModel() {
        isLoadingAnimation.onNext(true)
        
        let parameter: Observable<SearchMovieParams> = Observable.combineLatest(queryString.asObservable(), page.asObservable()) { (query, page) ->  SearchMovieParams in
            let param = SearchMovieParams(query: query, page: page)
            self.offset = page
            self.searchParam = Variable<SearchMovieParams>(param)
            return param
        }
        
        // --- Setup movies results list Observable ---
        moviesResultObservable = parameter.flatMapLatest { (param) -> Observable<MovieResults?> in
            self.isLoadingAnimation.onNext(true)
            return self.homeSearchService.getMoviesWithParam(param: param, completion: { [weak self] (results, error) in
                if error != nil {
                    self?.errorObservable.onNext(error as! CTNetworkErrorType)
                } else {
                    self?.setupModelWithNewResults(results: results)
                }
            })
            .share(replay: 1)
        }
        
    }
    
    func setupViewModelForSuggestion(searchTextField: Reactive<CareemSearchBar>) {
        // --- Setup suggestions Observable list ---
        suggestionsObservable = searchTextField.textDidBeginEditing
            .asObservable()
            .flatMapLatest { (_) -> Observable<[Suggestion]> in
                return Observable.just(Suggestion.getListSuggestions())
            }.share(replay: 1)
    }
    
    /// Lazy loading method
    ///
    /// - Parameter offset: the next page
    /// - Returns: Observable that we need to triger
    override func loadData(offset: Int) -> Observable<[Movie]> {
        self.isLoadingAnimation.onNext(true)
        searchParam.value.page = offset 
        let observable: Observable<[Movie]> = HomeMoviesService.getMoviesArrayWithParam(param: searchParam.value, keyPath: "results")
            .observeOn(MainScheduler.instance)
            .map { (value) -> [Movie] in
                return value
        }
        observable.subscribe { (_ ) in
            self.isLoadingAnimation.onNext(false)
            }.disposed(by: disposeBag)
        return observable
    }
    
    //MARK: - Supporting methods
    
    /// Setup data of view model after fetched results
    ///
    /// - Parameter results: results was found
    fileprivate func setupModelWithNewResults(results: MovieResults?) {
        guard let value = results, value.totaResults > 0 else { return }
        self.elements.value = value.results
        self.maxOffset = value.totalPages
        self.isLoadingAnimation.onNext(false)
        self.saveSuggestion(query: self.searchParam.value.query, totalResult: value.totaResults.description)
    }
    
    
    /// Save the suggestion after search with keyword successful
    ///
    /// - Parameters:
    ///   - query: query string
    ///   - totalResult: total results found
    fileprivate func saveSuggestion(query: String, totalResult: String) {
        let suggestion = Suggestion.createSuggestionObject(name: query, totalResult: totalResult)
        suggestion.saveLatestSuggestion()
    }
    
}
