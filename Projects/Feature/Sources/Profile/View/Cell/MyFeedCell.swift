//
//  MyFeedCell.swift
//  Feature
//
//  Created by 이범준 on 2024/01/08.
//

import UIKit
import DesignSystem

final class MyFeedCell: BaseCollectionViewCell<TempMyFeedModel> {
    
    static let reuseIdentifer = "MyFeedCell"
    
    lazy var containerView = TouchableView().then({
        $0.backgroundColor = DesignSystemAsset.black.color
    })
    
    private lazy var dateLabel = UILabel().then({
        $0.text = "12월 10일(일요일)"
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var feedImageView = UIView().then({
        $0.backgroundColor = .red
        $0.layer.cornerRadius = moderateScale(number: 20)
    })
    
    private lazy var feedCountView = UIView().then({
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = moderateScale(number: 6)
    })
    
    private lazy var feedTitleLabel = UILabel().then({
        $0.text = "썸네일이 위스키인 피드들에 최적의 소맥의 비율을 묻다"
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var feedDescriptionLabel = UILabel().then({
        $0.text = "이번에 위스키를 처음 먹어봤습니다.맨날 하이볼로만 먹다가 온더락으로 마셔봤는데, 향이 좋았습니다. 안주의 맛이 강하지 않은 나초 오리지널과 먹"
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var viewCountImageView = UIImageView().then({
        $0.image = UIImage(named: "eye")
    })
    
    private lazy var viewCountLabel = UILabel().then({
        $0.text = "test"
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var commentImageView = UIImageView().then({
        $0.image = UIImage(named: "comment")
    })
    
    private lazy var commentLabel = UILabel().then({
        $0.text = "test"
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var likeImageView = UIImageView().then({
        $0.image = UIImage(named: "like")
    })
    
    private lazy var likeCountLabel = UILabel().then({
        $0.text = "test"
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([dateLabel,
                                   feedImageView,
                                   feedCountView,
                                   feedTitleLabel,
                                   feedDescriptionLabel,
                                   viewCountImageView,
                                   viewCountLabel,
                                   commentImageView,
                                   commentLabel,
                                   likeImageView,
                                   likeCountLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: -10))
            $0.trailing.bottom.top.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
            $0.leading.equalToSuperview()
        }
        feedImageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 353))
        }
        feedCountView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 16))
            $0.bottom.equalTo(feedTitleLabel.snp.top).offset(moderateScale(number: 4))
        }
        feedTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 16))
            $0.trailing.equalToSuperview().offset(moderateScale(number: -77))
            $0.bottom.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: -16))
        }
        feedDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview()
            // TODO: - 바텀 이어줘야 할듯
//            $0.bottom.equalTo(viewCountImageView.snp.top).offset(moderateScale(number: 11))
        }
        viewCountImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(moderateScale(number: -19))
        }
        viewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(viewCountImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        commentImageView.snp.makeConstraints {
            $0.leading.equalTo(viewCountLabel.snp.trailing).offset(moderateScale(number: 16))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        commentLabel.snp.makeConstraints {
            $0.leading.equalTo(commentImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        likeImageView.snp.makeConstraints {
            $0.leading.equalTo(commentLabel.snp.trailing).offset(moderateScale(number: 16))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeImageView.snp.trailing).offset(moderateScale(number: 4))
            $0.centerY.equalTo(viewCountImageView.snp.centerY)
        }
    }
    
    override func bind(_ model: TempMyFeedModel) {
        super.bind(model)

    }
}
