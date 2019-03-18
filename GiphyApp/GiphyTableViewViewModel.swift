//
//  GiphyViewModel.swift
//  GiphyApp
//
//  Created by Marcis Nimants on 17/03/2019.
//  Copyright © 2019 Marcis Nimants. All rights reserved.
//

import RxSwift
import RxCocoa

class GiphyTableViewViewModel {
    let searchTextObservable = PublishSubject<String>()
    let gifItemsObservable: Observable<[Gif]>
    
    init() {
        gifItemsObservable = searchTextObservable
            .asObservable()
            .flatMapLatest { query -> Observable<[Gif]> in
                if query.isEmpty {
                    return .just([])
                }
                
                return GiphyApi()
                    .getGifs(byKeyword: query)
                    .catchErrorJustReturn([])
                    .asObservable()
        }
    }
}
