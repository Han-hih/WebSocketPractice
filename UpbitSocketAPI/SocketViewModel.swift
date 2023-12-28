//
//  SocketViewModel.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/28/23.
//

import Foundation
import RxSwift

class SocketViewModel: ObservableObject {
    
    var dataSubject = BehaviorSubject<TickerModel>(value: TickerModel.init(type: "", code: "", streamType: "", tradePrice: 0.0))
    
    private let disposeBag = DisposeBag()
    
    init() {
        WebSocketManager.shared.openWebSocket()
        
        WebSocketManager.shared.send()
        
        WebSocketManager.shared.tickerSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] ticker in
                guard let self else { return }
                self.dataSubject.onNext(ticker)
                print("💴",ticker)
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        WebSocketManager.shared.closeWebSocket()
    }
    
}
