//
//  WebSocketManager.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/28/23.
//

import Foundation
import RxSwift

final class WebSocketManager: NSObject {
    static let shared = WebSocketManager()
    
    private var timer: Timer?
    private var webSocket: URLSessionWebSocketTask?
    private var isOpen = false
    
    var tickerSubject = PublishSubject<TickerModel>()
    
    func openWebSocket() {
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            webSocket = session.webSocketTask(with: url)
            
            webSocket?.resume()
        }
    }
    
    func closeWebSocket() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        
        timer?.invalidate()
        timer = nil
        
        isOpen = false
    }
    
    func send() {
        let query = """
                     [{ "ticket": "test example" },
                       { "type": "ticker", 
                         "codes": [
                           "KRW-BTC"
                         ]},
                       { "format": "DEFAULT" }]
                     """
        webSocket?.send(.string(query), completionHandler: { error in
            if let error {
                print("send error, \(error)")
            }
        })
    }
    
    func receive() {
        if isOpen {
            webSocket?.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let success):
                    print("receive success, \(success)")
                    switch success {
                    case .data(let data):
                        if let decodedData = try? JSONDecoder().decode(TickerModel.self, from: data) {
                            print("receive \(decodedData)")
                            self?.tickerSubject.onNext(decodedData)
                        }
                    case .string(let string): print(string)
                    @unknown default:
                        fatalError()
                    }
                case .failure(let failure):
                    print("receive failure, \(failure)")
                    self?.closeWebSocket()
                }
                self?.receive()
            })
        }
    }
    
    func ping() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error {
                    print("ping pong error")
                } else {
                    print("ping")
                }
            })
        })
    }
    
    private override init() {
        super.init()
    } 
    
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    
    //didOpen: 웹소켓 연결이 되었는 지 확인
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket OPEN")
        isOpen = true
        receive()
    }
    
    //didClose: 웹소켓이 연결 해제되었는 지 확인
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket CLOSE")
        isOpen = false
    }
}
