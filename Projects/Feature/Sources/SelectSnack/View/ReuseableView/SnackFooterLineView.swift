//
//  SnackFooterLineView.swift
//  Feature
//
//  Created by 김유진 on 2023/12/14.
//

import UIKit
import DesignSystem

final class SnackFooterLineView: UITableViewHeaderFooterView {
    static let id = "\(SnackFooterLineView.self)"
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray400.color
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SnackFooterLineView {
    private func layout() {
        addSubview(lineView)
        
        lineView.snp.makeConstraints {
            $0.center.width.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 1))
        }
    }
}
