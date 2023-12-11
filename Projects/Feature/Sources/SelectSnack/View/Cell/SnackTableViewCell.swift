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
    
    private lazy var cellBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.isHidden = true
    }
    
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
        if let snackName = snack.name {
            if let highlightedText = snack.highlightedText {
                
                let attributedString = NSMutableAttributedString(string: snackName)
                let highlightRange = (snackName as NSString).range(of: highlightedText)
                let yellowColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
                
                attributedString.addAttribute(.foregroundColor, value: yellowColor, range: highlightRange)
                snackNameLabel.attributedText = attributedString
            } else {
                snackNameLabel.text = snack.name
            }
        }
        
        checkImageView.isHidden = !(snack.isSelect ?? false)
        cellBackgroundView.isHidden = !(snack.isSelect ?? false)
    }
    
    private func layout() {
        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(snackNameLabel)
        contentView.addSubview(checkImageView)
        
        cellBackgroundView.snp.makeConstraints {
            $0.bottom.width.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        snackNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(moderateScale(number: 2))
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.centerY.equalToSuperview().offset(moderateScale(number: 2))
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
