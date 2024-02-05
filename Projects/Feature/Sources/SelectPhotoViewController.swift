//
//  SelectPhotoViewController.swift
//  Feature
//
//  Created by 김유진 on 2/5/24.
//

import UIKit
import Combine
import DesignSystem

public class SelectPhotoViewController: BaseViewController {
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_leftArrow")?.withTintColor(DesignSystemAsset.gray900.color), for: .normal)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "새 피드 작성"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    }
    
    private lazy var nextButton = UILabel().then {
        $0.text = "다음"
        $0.textColor = DesignSystemAsset.main.color
        $0.font = Font.semiBold(size: 14)
    }
    
    private lazy var selectedImageView = UIImageView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var bottomShadowView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
    }
    
    private lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = moderateScale(number: 6)
        $0.minimumInteritemSpacing = moderateScale(number: 5.67)
    }
    
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        view.addSubviews([
            backButton,
            titleLabel,
            nextButton,
            selectedImageView,
            imageCollectionView,
            bottomShadowView
        ])
    }
    
    public override func makeConstraints() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 73))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        selectedImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 393))
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 12))
            $0.centerX.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(selectedImageView.snp.bottom).offset(moderateScale(number: 16))
        }
        
        bottomShadowView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 74))
        }
    }
}
