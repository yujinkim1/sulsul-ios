//
//  SettingViewController.swift
//  Feature
//
//  Created by 이범준 on 12/31/23.
//

import UIKit
import Then
import DesignSystem

public final class SettingViewController: BaseViewController {
    var coordinator: MoreBaseCoordinator?
    
    private lazy var topHeaderView = UIView()
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    private lazy var titleLabel = UILabel().then({
        $0.text = "설정"
        $0.font = Font.bold(size: 32)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    private lazy var settingStackView = UIStackView().then({
        $0.axis = .vertical
        $0.distribution = .fillEqually
    })
    private lazy var managementTitleLabel = UILabel().then({
        $0.text = "취향 관리"
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray500.color
    })
    private lazy var drinkSettingView = SettingView(settingType: .arrow,
                                                    title: "술 설정")
    private lazy var snackSettingView = SettingView(settingType: .arrow,
                                                    title: "안주 설정")
    private lazy var appSettingTitleLabel = UILabel().then({
        $0.text = "앱 설정"
        $0.font = Font.regular(size: 14)
        $0.textColor = DesignSystemAsset.gray500.color
    })
    private lazy var alarmSettingView = SettingView(settingType: .toggle,
                                                    title: "알림")
    private lazy var feedBackSettingView = SettingView(settingType: .arrow,
                                                       title: "피드백")
    private lazy var termsSettingView = SettingView(settingType: .arrow,
                                                    title: "이용약관")
    private lazy var personalSettingView = SettingView(settingType: .arrow,
                                                       title: "개인정보 처리방침")
    private lazy var signOutSettingView = SettingView(settingType: .arrow,
                                                      title: "회원탈퇴")
    private lazy var logoutTouchaleLabel = TouchableLabel().then({
        $0.text = "로그아웃"
        $0.font = Font.bold(size: 16)
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        super.addViews()
        view.addSubviews([topHeaderView,
                          scrollView])
        scrollView.addSubview(containerView)
        containerView.addSubviews([titleLabel,
                                   settingStackView,
                                   logoutTouchaleLabel])
        settingStackView.addArrangedSubviews([managementTitleLabel,
                                             drinkSettingView,
                                             snackSettingView,
                                             appSettingTitleLabel,
                                             alarmSettingView,
                                             feedBackSettingView,
                                             termsSettingView,
                                             personalSettingView,
                                             signOutSettingView])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        settingStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 378))
        }
        logoutTouchaleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(moderateScale(number: -38))
            $0.centerX.equalToSuperview()
        }
    }
}
