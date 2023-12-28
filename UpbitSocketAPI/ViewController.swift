//
//  ViewController.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/26/23.
//

import UIKit
import SnapKit
import RxSwift

final class ViewController: UIViewController {

    private var stockLabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20)
        return lb
    }()
    
    private var priceLabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20)
        return lb
    }()
 
    private let viewModel = SocketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        
    }

    private func setUI() {
        view.addSubview(stockLabel)
        view.addSubview(priceLabel)
        
        stockLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(stockLabel.snp.trailing).offset(20)
        }
      
         
    }
    
    
    

}

