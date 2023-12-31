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

public final class SettingView: UIView {
    
    private var settingType: SettingType = .arrow
    
    private lazy var containerView = UIView()

    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    }
    
    private lazy var arrowTouchableImageView = TouchableImageView

    init() {
        super.init(frame: UIScreen.main.bounds)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(settingType: SettingType?, title: String) {
        guard let settingType = settingType else { return }
        titleLabel.text = title
        self.settingType = settingType
    }
    
    private func addViews() {
        addSubviews([containerView])
        containerView.addSubviews([toastImageView,
                                    titleLabel])
    }
    
    private func makeConstraints() {

    }
}
