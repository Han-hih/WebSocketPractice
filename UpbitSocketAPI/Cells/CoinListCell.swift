//
//  CoinListCell.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/30/23.
//

import UIKit

class CoinListCell: UITableViewCell {
    
    private let starImage = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star")
        return image
    }()
    
    private let coinNameLabel = {
        let lb = UILabel()
        return lb
    }()
    
    private let coinCodeLabel = {
        let lb = UILabel()
        lb.textColor = .darkGray
        lb.font = .systemFont(ofSize: 12)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        [starImage, coinNameLabel, coinCodeLabel].forEach {
            self.addSubview($0)
        }
        
        starImage.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }
        
        coinNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImage.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(5)
        }
        
        coinCodeLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinNameLabel)
            make.top.equalTo(coinNameLabel.snp.bottom)
        }
    }
    
    func configure(like: Bool, name: String, code: String) {
        starImage.image = UIImage(systemName: like ? "star.fill" : "star")
        coinNameLabel.text = name
        coinCodeLabel.text = code
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
