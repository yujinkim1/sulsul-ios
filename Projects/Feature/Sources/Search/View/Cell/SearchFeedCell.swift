//
//  SearchFeedCell.swift
//  Feature
//
//  Created by 김유진 on 3/20/24.
//

import UIKit
import DesignSystem

final class SearchFeedCell: UITableViewCell {
    static let id = "SearchFeedCell"
    
    private lazy var feedImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = moderateScale(number: 8.55)
    }
    
    private lazy var firstTagLabel = PaddingLabel().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = DesignSystemAsset.gray200.color
    }
    
    private lazy var andLabel = UILabel().then {
        $0.text = "&"
        $0.textColor = DesignSystemAsset.gray200.color
        $0.font = Font.regular(size: 12)
    }
    
    private lazy var secondTagLabel = PaddingLabel().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = DesignSystemAsset.gray200.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray500.color
        $0.font = Font.bold(size: 18)
        $0.numberOfLines = 2
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray500.color
    }
    
    private lazy var nextButton = UIImageView(image: UIImage(named: "common_rightArrow")?.withTintColor(DesignSystemAsset.gray700.color))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = DesignSystemAsset.black.color
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ model: Pairing) {
        if let url = URL(string: model.image ?? "") {
            feedImageView.kf.setImage(with: url)
        }
    }
}

extension SearchFeedCell {
    private func addViews() {
        addSubviews([
            feedImageView,
            firstTagLabel,
            andLabel,
            secondTagLabel,
            titleLabel,
            lineView
        ])
    }
    
    private func makeConstraints() {
        feedImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 86))
            $0.top.leading.equalToSuperview()
        }
        
        firstTagLabel.snp.makeConstraints {
            $0.leading.equalTo(feedImageView.snp.trailing).offset(moderateScale(number: 16))
            $0.top.equalTo(feedImageView)
        }
        
        andLabel.snp.makeConstraints {
            $0.centerY.equalTo(firstTagLabel)
            $0.leading.equalTo(firstTagLabel.snp.trailing).offset(moderateScale(number: 4))
        }
        
        secondTagLabel.snp.makeConstraints {
            $0.leading.equalTo(andLabel.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalTo(firstTagLabel)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(feedImageView)
            $0.leading.equalTo(firstTagLabel)
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(feedImageView)
            $0.trailing.equalTo(titleLabel)
        }
    }
}
