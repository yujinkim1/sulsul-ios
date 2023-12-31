//
//  settingView.swift
//  Feature
//
//  Created by 이범준 on 12/31/23.
//

import UIKit
import DesignSystem

public enum SettingType {
    case arrow
    case toggle
}

final class SettingView: UIView {
    
    private var settingType: SettingType = .arrow
    
    lazy var containerView = TouchableView()

    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    }
    
    private lazy var arrowTouchableImageView = UIImageView().then({
        $0.image = UIImage(named: "common_rightArrow")
        $0.isHidden = true
    })
    
    private lazy var settingToggle = UISwitch().then({
        $0.isHidden = true
    })
    
    convenience init(settingType: SettingType, title: String) {
        self.init()
        self.settingType = settingType
        titleLabel.text = title
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
    
    private func addViews() {
        addSubviews([containerView])
        containerView.addSubviews([titleLabel,
                                   arrowTouchableImageView,
                                   settingToggle])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 10))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        arrowTouchableImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
        }
        settingToggle.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
        }
    }
}
