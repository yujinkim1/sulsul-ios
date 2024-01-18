//
//  EditProfileViewController.swift
//  Feature
//
//  Created by 이범준 on 2024/01/10.
//

import Combine
import UIKit
import DesignSystem
import MobileCoreServices

public final class ProfileEditViewController: DisappearKeyBoardBaseViewController {
    
    var coordinator: MoreBaseCoordinator?
    
    private var cancelBag = Set<AnyCancellable>()
    private var randomNickname = ""
    
    private lazy var topHeaderView = BaseTopView()
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "프로필 수정"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    })
    
    private lazy var profileTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(systemName: "circle.fill")
    })
    
    private lazy var modifyProfileButton = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 16)
    })
    
    private lazy var modifyProfileLabel = UILabel().then({
        $0.text = "사진 변경"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var induceUserNameLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.text = "닉네임 변경"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var userNameTextField = UITextField().then {
        $0.rightView = clearButton
        $0.rightViewMode = .always
        $0.font = Font.bold(size: 32)
        $0.tintColor = DesignSystemAsset.white.color
        $0.placeholder = "닉네임을 입력해주세요."
    }
    
    private lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "filled_clear"), for: .normal)
    }

    private lazy var resetTouchableLabel = TouchableLabel().then({
        $0.text = "랜덤 닉네임 쓸래요!"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray400.color
    })
    
    private lazy var specializeGuideImageView = UIImageView().then({
        $0.image = UIImage(named: "common_snackCheck")
    })
    
    private lazy var specializeGuidLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.text = "입력된 특수문자가 없어요."
    })
    
    private lazy var countGuideImageView = UIImageView().then({
        $0.image = UIImage(named: "common_snackCheck")
    })
    
    private lazy var countGuideLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.text = "적절한 글자수의 닉네임이에요."
    })
    
    private lazy var nextButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.layer.cornerRadius = CGFloat(12)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(DesignSystemAsset.gray200.color, for: .normal)
        $0.isEnabled = true
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        self.showCameraBottomSheet(selectCameraCompletion: nil,
                                   selectAlbumCompletion: nil,
                                   baseCompletion: nil)
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    public override func addViews() {
        topHeaderView.addSubviews([titleLabel])
        view.addSubviews([topHeaderView,
                          profileTouchableImageView,
                          modifyProfileButton,
                          induceUserNameLabel,
                          userNameTextField,
                          resetTouchableLabel,
                          specializeGuideImageView,
                          specializeGuidLabel,
                          countGuideImageView,
                          countGuideLabel,
                          nextButton])
        modifyProfileButton.addSubview(modifyProfileLabel)
        userNameTextField.addSubview(clearButton)
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 59))
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        profileTouchableImageView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 80))
        }
        modifyProfileButton.snp.makeConstraints {
            $0.top.equalTo(profileTouchableImageView.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 32))
            $0.width.equalTo(moderateScale(number: 107))
        }
        modifyProfileLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        induceUserNameLabel.snp.makeConstraints {
            $0.top.equalTo(modifyProfileButton.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(induceUserNameLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 40))
        }
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        specializeGuideImageView.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(moderateScale(number: 19))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 16))
        }
        specializeGuidLabel.snp.makeConstraints {
            $0.centerY.equalTo(specializeGuideImageView.snp.centerY)
            $0.leading.equalTo(specializeGuideImageView.snp.trailing).offset(moderateScale(number: 6))
        }
        countGuideImageView.snp.makeConstraints {
            $0.top.equalTo(specializeGuidLabel.snp.bottom).offset(moderateScale(number: 10))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 16))
        }
        countGuideLabel.snp.makeConstraints {
            $0.centerY.equalTo(countGuideImageView.snp.centerY)
            $0.leading.equalTo(countGuideImageView.snp.trailing).offset(moderateScale(number: 6))
        }
        resetTouchableLabel.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(topHeaderView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 50))
        }
    }
    
    public override func setupIfNeeded() {
        topHeaderView.backTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
