//
//  CoinListViewModel.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/30/23.
//

import Foundation
import RxSwift

class CoinListViewModel: ViewModelType {
    
    //    private let coinList = PublishSubject<[UpbitList]>()
    
    let disposeBag = DisposeBag()
    
    
    let url = "https://api.upbit.com/v1/market/all"
    
    struct Input {
        let networkResult: Observable<Void>
        let krwButtonTapped: Observable<Void>
        let btcButtonTapped: Observable<Void>
        let allButtonTapped: Observable<Void>
        
    }
    
    struct Output {
        let coinList: Observable<[UpbitList]>
        let krwCoinList: Observable<[UpbitList]>
        let btcCoinList: Observable<[UpbitList]>
        let allCoinList: Observable<[UpbitList]>
    }
    
    func transform(input: Input) -> Output {
        
        let upbitList = transCoinList { _ in true }
        
        let krwCoinList = transCoinList { $0.market.contains("KRW") }
        
        let btcCoinList = transCoinList { $0.market.contains("BTC-") }
        
        let allCoinList = transCoinList { _ in true }
        
        func transCoinList(filter: @escaping (UpbitList) -> Bool) -> Observable<[UpbitList]> {
            return input.networkResult
                .flatMapLatest { [unowned self] _ -> Observable<[UpbitList]> in
                    return APIManager.shared.getAPIRequest(type: [UpbitList].self, url: url).map { $0.filter(filter) }
                }
        }
        
        return Output(
            coinList: upbitList,
            krwCoinList: krwCoinList,
            btcCoinList: btcCoinList,
            allCoinList: allCoinList
        )
    }
}
