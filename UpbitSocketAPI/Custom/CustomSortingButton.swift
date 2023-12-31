//
//  CustomSortingButton.swift
//  UpbitSocketAPI
//
//  Created by 황인호 on 12/31/23.
//

import UIKit

final class CustomSortingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    private func setButton() {
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
