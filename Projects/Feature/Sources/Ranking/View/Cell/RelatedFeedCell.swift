//
//  RelatedFeedCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-04.
//

import UIKit
import DesignSystem

final class RelatedFeedCell: BaseCollectionViewCell<RankingItem> {
    static let reuseIdentifier = "RecommendSnackCell"
    
    private lazy var containerView = UIView().then {
        $0.layer.borderWidth = 0
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    
    private lazy var backgroundImageView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var heartImageView = UIImageView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var usernameLabel = UILabel().then {
        $0.setLineHeight(36)
        $0.textAlignment = .center
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(36)
        $0.textAlignment = .center
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.text = "나초"
    }
    
    private lazy var scoreStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = CGFloat(0)
    }
    
    private lazy var scoreImageView = UIImageView().then {
        $0.image = UIImage(named: "hand_clapping")
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.setLineHeight(18)
        $0.textAlignment = .center
        $0.font = Font.bold(size: 12)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.text = "0.0/5"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        rankLabel.text = nil
//        snackNameLabel.text = nil
//        firstSnackImageView.image = nil
//        secondSnackImageView.image = nil
//        thirdSnackImageView.image = nil
//    }
    
    override func bind(_ model: RankingItem) {
        super.bind(model)
        
        configure(model)
    }
    
    // MARK: - Custom Method
    
    private func addViews() {
        containerView.addSubviews([
            profileImageView,
            usernameLabel,
            titleLabel,
            scoreImageView,
            scoreLabel,
        ])
        
        addSubview(containerView)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(moderateScale(number: 10))
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(usernameLabel.snp.trailing).offset(moderateScale(number: 8))
            $0.top.equalTo(usernameLabel)
        }
        scoreLabel.snp.makeConstraints {
            $0.trailing.equalTo(containerView.snp.trailing).offset(moderateScale(number: -10))
            $0.top.equalToSuperview().offset(moderateScale(number: 25))
        }
        scoreImageView.snp.makeConstraints {
            $0.trailing.equalTo(scoreLabel.snp.leading).offset(moderateScale(number: -4))
            $0.top.equalToSuperview().offset(moderateScale(number: 25))
            $0.size.equalTo(moderateScale(number: 16))
        }
    }
    
    private func configure(_ model: RankingItem) {
//        if let rank = model.rank {
//            rankLabel.text = String(rank)
//        } else {
//            print("Rank value is not available.")
//        }
//
//        if let imageURLString = model.drink?.image,
//           let imageURL = URL(string: imageURLString) {
//            drinkImageView.loadImage(imageURL)
//        } else {
//            print("Image URL is not available.")
//            drinkImageView.image = UIImage()
//        }
//
//        if let subtype = model.drink?.subtype {
//            subtypeLabel.text = String(subtype)
//        } else {
//            print("Subtype value is not available.")
//        }
//
//        if let drinkName = model.drink?.name {
//            drinkNameLabel.text = drinkName
//        } else {
//            print("Drink name is not available.")
//        }
    }
}
