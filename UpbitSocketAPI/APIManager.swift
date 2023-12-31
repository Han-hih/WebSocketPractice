//
//  APIRequest.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/30/23.
//

import Foundation
import RxSwift

    enum APIError: Error {
        case invalidURL
        case unknownResponse
        case statusError
    }
    
class APIManager {
    
    static let shared = APIManager()
    
    func getAPIRequest<T: Decodable>(type: T.Type, url: String) -> Observable<T> {
        
        return Observable<T>.create { observer in
            
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                print(url)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                print("DataTask Succeed")
                if let _ = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(T.self, from: data) {
                    observer.onNext(appData)
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
