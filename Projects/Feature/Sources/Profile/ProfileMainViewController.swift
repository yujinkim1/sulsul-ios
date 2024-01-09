//
//  ProfileMainViewController.swift
//  Feature
//
//  Created by 이범준 on 2024/01/08.
//

import UIKit
import Then
import DesignSystem

public final class ProfileMainViewController: BaseViewController {
    var coordinator: MoreBaseCoordinator?
    
    private lazy var topHeaderView = UIView()
    private lazy var searchTouchableIamgeView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_search")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    private lazy var alarmTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(named: "common_alarm")
        $0.tintColor = DesignSystemAsset.gray900.color
    })
    private lazy var containerView = UIView()
    
    private lazy var profileView = UIView()
    
    private lazy var profileLabel = UILabel().then({
        $0.text = "testestese"
        $0.font = Font.bold(size: 32)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    private lazy var profileEditTouchableLabel = TouchableLabel().then({
        $0.text = "프로필 수정"
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray300.color
    })
    
    private lazy var profileTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(systemName: "circle.fill")
    })
    
    private lazy var selectFeedView = UIStackView().then({
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    })
    
    private lazy var myFeedTouchableView = TouchableView().then({
        $0.backgroundColor = .red
    })
    
    private lazy var likeFeedTouchableView = TouchableView().then({
        $0.backgroundColor = .blue
    })
    
    private lazy var likeFeedView = LikeFeedView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          containerView])
        topHeaderView.addSubviews([searchTouchableIamgeView,
                                   alarmTouchableImageView])
        containerView.addSubviews([profileView,
                                   selectFeedView,
                                   likeFeedView])
        profileView.addSubviews([profileLabel,
                                 profileEditTouchableLabel,
                                 profileTouchableImageView])
        selectFeedView.addArrangedSubviews([myFeedTouchableView,
                                            likeFeedTouchableView])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        searchTouchableIamgeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(alarmTouchableImageView.snp.leading).offset(moderateScale(number: -12))
            $0.size.equalTo(moderateScale(number: 24))
        }
        alarmTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 72))
        }
        profileLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        profileEditTouchableLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
        profileTouchableImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 64))
        }
        selectFeedView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 40))
        }
        myFeedTouchableView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        likeFeedTouchableView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        likeFeedView.snp.makeConstraints {
            $0.top.equalTo(selectFeedView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}


