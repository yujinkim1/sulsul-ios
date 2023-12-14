//
//  SearchResultEmptyView.swift
//  Feature
//
//  Created by 김유진 on 2023/12/14.
//

import UIKit
import DesignSystem

final class SearchResultEmptyView: UIView {
    
    private lazy var emptyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 64)
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private lazy var emptyDescriptionLabel = UILabel().then {
        $0.font = Font.regular(size: 16)
        $0.text = "앗, 죄송해요! 😅\n입력하신 안주가 아직 등록되지 않은것 같아요.\n저희가 몰랐던 다양한 안주를 알려주시겠어요?"
        $0.textColor = DesignSystemAsset.gray600.color
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    lazy var addSnackButton = UIButton().then {
        $0.setTitle("안주 추가하러 가기", for: .normal)
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.setTitleColor(DesignSystemAsset.gray700.color, for: .normal)
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = DesignSystemAsset.gray200.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SearchResultEmptyView {
    private func addViews() {
        addSubview(emptyStackView)
        emptyStackView.addArrangedSubviews([emptyDescriptionLabel, addSnackButton])
    }
    
    private func makeConstraints() {
        emptyStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 40))
            $0.width.centerX.equalToSuperview()
        }
        
        addSnackButton.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 40))
            $0.width.equalTo(moderateScale(number: 166))
        }
    }
}
