//
//  RelatedFeedCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-13.
//

import UIKit
import DesignSystem

final class RelatedFeedCell: UICollectionViewCell {
    static let reuseIdentifier = "RelatedFeedCell"
    
    // MARK: - Components
    //
    private lazy var imageView = UIImageView().then {
        $0.frame = .zero
        $0.backgroundColor = DesignSystemAsset.gray400.color
        $0.layer.cornerRadius = CGFloat(8)
        $0.layer.masksToBounds = true
    }
    
    private lazy var drinkLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.regular(size: 10))
        $0.numberOfLines = 1
        $0.font = Font.regular(size: 10)
        $0.text = "잭 다니엘스"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(24, font: Font.bold(size: 18))
        $0.numberOfLines = 1
        $0.font = Font.bold(size: 18)
        $0.text = "맛있고 건간한 채식 요리와 함께 마시는 잭 다니엘스"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.setLineHeight(16, font: Font.bold(size: 10.67))
        $0.font = Font.bold(size: 10.67)
        $0.text = "4.8/5"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom method
    private func addViews() {
        self.addSubview(imageView)
        self.contentView.addSubviews([
            self.titleLabel,
            self.drinkLabel,
            self.scoreLabel
        ])
    }
    
    private func makeConstraints() {
        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 8))
        }
        
        self.drinkLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.titleLabel)
            $0.bottom.equalTo(self.titleLabel.snp.top)
        }
        
        self.scoreLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.titleLabel)
            $0.bottom.equalTo(self.drinkLabel.snp.top)
        }
    }
}
