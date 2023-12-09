//
//  SnackTableViewCell.swift
//  Feature
//
//  Created by 김유진 on 2023/12/04.
//

import UIKit
import DesignSystem

final class SnackTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SnackTableViewCell"
    
    private lazy var snackNameLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.textColor = .white
    }
    
    private lazy var checkImageView = UIImageView().then {
        $0.image = UIImage(named: "common_snackCheck")
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = DesignSystemAsset.black.color

        layout()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(snack: Pairing) {
        snackNameLabel.text = snack.name
        checkImageView.isHidden = !(snack.isSelect ?? false)
    }
    
    private func layout() {
        contentView.addSubview(snackNameLabel)
        contentView.addSubview(checkImageView)
        
        snackNameLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
