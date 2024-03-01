//
//  PreferenceCell.swift
//  Feature
//
//  Created by 이범준 on 2/18/24.
//

import UIKit
import DesignSystem

final class MainPreferenceCell: BaseCollectionViewCell<Feed> {
    
    static let reuseIdentifer = "LikeFeedCell"
    
    lazy var containerView = TouchableView().then({
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
    })
    
    private lazy var feedImageView = UIImageView().then({
        $0.layer.cornerRadius = 12
        $0.image = UIImage(systemName: "circle.fill")
    })
    
    private lazy var feedTimeLabel = UILabel().then({
        $0.text = "5분전"
        $0.font = Font.regular(size: 10)
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var feedTitleLabel = UILabel().then({
        $0.text = "자연 친화적인 머시기"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.white.color
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
        containerView.addSubviews([feedImageView,
                                   feedTimeLabel,
                                   feedTitleLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        feedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        feedTimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 8))
            $0.bottom.equalTo(feedTitleLabel.snp.top)
        }
        feedTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.bottom.equalToSuperview().offset(moderateScale(number: -8))
        }
    }
    
    override func bind(_ model: Feed) {
        super.bind(model)
        feedTitleLabel.text = model.title
        feedTimeLabel.text = model.updatedAt
        if let imageURL = URL(string: model.representImage) {
            feedImageView.kf.setImage(with: imageURL)
        }
    }
}
