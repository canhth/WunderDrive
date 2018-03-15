//
//  PaginationNetworkModel.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 8/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper

class PaginationNetworkModel<T1: Mappable>: NSObject {
    
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = Variable<Bool>(false)
    let elements = Variable<[T1]>([])
    var offset: Int = 1
    var maxOffset: Int = 1
    let error = PublishSubject<Swift.Error>()
    
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        let refreshRequest = loading.asObservable()
            .sample(refreshTrigger)
            .flatMap { loading -> Observable<Int> in
                if self.offset >= self.maxOffset {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { observer in
                        observer.onNext(0)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
        }
        
        let nextPageRequest = loading.asObservable()
            .sample(loadNextPageTrigger)
            .flatMap { [unowned self] loading -> Observable<Int> in
                if (self.offset > self.maxOffset) {
                    return Observable.empty()
                } else {
                    return Observable<Int>.create { [unowned self] observer in
                        self.offset += 1
                        observer.onNext(self.offset)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                }
        }
        
        let request = Observable
            .of(refreshRequest, nextPageRequest)
            .merge()
            .share(replay: 1)
        
        let response = request.flatMap { offset -> Observable<[T1]> in
            self.loadData(offset: offset)
                .do(onError: { [weak self] error in
                    self?.error.onNext(error)
                }).catchError({ error -> Observable<[T1]> in
                    Observable.empty()
                })
            }.share(replay: 1)
        
        Observable
            .combineLatest(request, response, elements.asObservable()) { [unowned self] request, response, elements in
                return self.offset == 0 ? response : elements + response
            }
            .sample(response)
            .bind(to: elements)
            .disposed(by: disposeBag)
        
        Observable
            .of(request.map{_ in true},
                response.map { $0.count == 0 },
                error.map { _ in false })
            .merge()
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
    
    func loadData(offset: Int) -> Observable<[T1]> { 
        return Observable.empty()
    }
}
