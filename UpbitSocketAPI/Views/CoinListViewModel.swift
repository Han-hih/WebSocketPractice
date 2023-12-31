//
//  CoinListViewModel.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/30/23.
//

import Foundation
import RxSwift

class CoinListViewModel: ViewModelType {

    private let coinList: [UpbitList] = []

    let url = "https://api.upbit.com/v1/market/all"
    
    struct Input {
        let networkResult: Observable<Void>
    }
    
    struct Output {
        let coinList: Observable<[UpbitList]>
    }
    
    
    
    func transform(input: Input) -> Output {
        let upbitList = input.networkResult
            .flatMapLatest { [unowned self] _ -> Observable<[UpbitList]> in
                print(123123123212313123)
                return APIManager.shared.getAPIRequest(type: [UpbitList].self, url: url).map { $0 }
            }
//            .subscribe(with: self) { owner, list in
//                print("list: \(list)")
//            }
//            .disposed(by: DisposeBag())
        
        return Output(coinList: upbitList)
//        return Output()
    }
}
