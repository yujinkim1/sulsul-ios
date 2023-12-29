//
//  ToastView.swift
//  DesignSystem
//
//  Created by 이범준 on 12/29/23.
//

import UIKit
import Then
import SnapKit

public final class ToastMessageView: UIView {
    private lazy var backgroundView = UIView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private lazy var toastImageView = UIImageView().then({
        $0.image = UIImage(named: "common_circleCheck")
    })

    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.white.color
        $0.font = Font.semiBold(size: 14)
        $0.textAlignment = .center
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.numberOfLines = 0
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
    
    private func addViews() {
        addSubviews([backgroundView])
        backgroundView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 81))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(moderateScale(number: -80))
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 24))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 12))
        }
        
    }
}
