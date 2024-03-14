//
//  CommentHeaderView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import UIKit
import DesignSystem

final class CommentHeaderView: UICollectionReusableView {
    static let reuseIdentifier: String = "CommentHeaderView"
    
    private lazy var parentImageView = UIImageView().then {
        $0.image = UIImage(named: "comment")
    }
    
    private lazy var parentTitleLabel = UILabel().then {
        $0.setLineHeight(28)
        $0.font = Font.bold(size: 18)
        $0.text = "댓글"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var countLabel = UILabel().then {
        $0.setLineHeight(28)
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func addViews() {
        addSubviews([
            parentImageView,
            parentTitleLabel,
            countLabel
        ])
    }
    
    private func makeConstraints() {
        parentImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(moderateScale(number: 24))
        }
        parentTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(parentImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.top.equalTo(parentImageView)
        }
    }
}
