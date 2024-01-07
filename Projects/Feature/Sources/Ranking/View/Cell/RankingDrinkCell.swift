//
//  RankingDrinkCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

final class RankingDrinkCell: BaseCollectionViewCell<RankingDrink> {
    
    static let reuseIdentifier = "RankingDrinkCell"
    
    private lazy var containerView = UIView().then {
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    private lazy var rankLabel = UILabel().then {
        $0.setTextLineHeight(height: 36)
        $0.textAlignment = .center
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var variationLabel = UILabel().then {
        $0.setTextLineHeight(height: 32)
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var variationImageView = UIImageView().then {
        $0.image = UIImage()
    }

    private lazy var drinkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "circle.fill")
    }

    private lazy var drinkNameLabel = UILabel().then {
        $0.setTextLineHeight(height: 32)
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
//    private lazy var variationStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.spacing = 0
//        $0.arrangedSubviews(variationImageView, variationLabel)
//    }
//
//    private lazy var infomationStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.spacing = 4
//        $0.arrangedSubviews(variationImageView, variationLabel)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func bind(_ model: RankingDrink) {
        super.bind(model)
        drinkNameLabel.text = model.name
        rankLabel.text = model.rank
    }
}

// MARK: - Custom Method

extension RankingDrinkCell {
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([
            rankLabel,
            variationLabel,
            variationImageView,
            drinkImageView,
            drinkNameLabel
        ])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 10))
            $0.top.equalToSuperview().offset(moderateScale(number: 13))
        }
        drinkImageView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(moderateScale(number: 4))
            $0.top.bottom.equalToSuperview().offset(8)
            $0.size.equalTo(moderateScale(number: 70))
        }
        drinkNameLabel.snp.makeConstraints {
            $0.leading.equalTo(drinkImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.top.bottom.equalToSuperview().offset(16)
        }
    }
}
