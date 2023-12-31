//
//  ViewModelType.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/30/23.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
