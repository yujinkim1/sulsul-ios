//
//  PreferenceCell.swift
//  Feature
//
//  Created by 이범준 on 2/18/24.
//

import UIKit
import DesignSystem

final class MainPreferenceCell: BaseCollectionViewCell<Feed> {
    
    lazy var containerView = TouchableView().then({
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
    })
    
    private lazy var feedImageView = UIImageView().then({
        $0.layer.cornerRadius = 12
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
        containerView.addSubviews([feedImageView])
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
