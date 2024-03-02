//
//  RankingPageTabBarCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-05.
//

import DesignSystem
import UIKit

final class RankingPageTabBarCell: UICollectionViewCell {
    static let reuseIdentifier = "RankingPageTabBarCell"
    
    private lazy var titleLabel = UILabel().then {
        $0.frame = .zero
        $0.textColor = DesignSystemAsset.gray300.color
        $0.font = Font.medium(size: 18)
        $0.setLineHeight(28)
        $0.textAlignment = .center
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
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? DesignSystemAsset.main.color : DesignSystemAsset.gray300.color
            titleLabel.font = isSelected ? Font.bold(size: 18) : Font.medium(size: 18)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Custom Method

extension RankingPageTabBarCell {
    private func addViews() {
        addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    public func configure(text: String) {
        titleLabel.text = text
    }
}
