//
//  WritePostTextViewController.swift
//  Feature
//
//  Created by 김유진 on 2/15/24.
//

import UIKit
import DesignSystem

final class WriteTitleViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator?
    
    private lazy var thumnailImageView = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray
        $0.clipsToBounds = true
    }
    
    private lazy var titleTextView = UITextView().then {
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.backgroundColor = .clear
    }
    
    private lazy var imageScrollView = UIScrollView()
    
    private lazy var imageStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
        $0.layoutMargins = UIEdgeInsets(top: 0, left: moderateScale(number: 20), bottom: 0, right: moderateScale(number: 20))
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var reSelectPhotoLabel = UILabel().then {
        $0.text = "사진을 다시 선택하고 싶어요."
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.bold(size: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderText("썸네일&제목입력", actionText: "다음")
        
        reSelectPhotoLabel.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setSelectedImages(_ images: [UIImage]) {
        images.enumerated().forEach { index, image in
            let imageView = SelectableImageView(image: image)
            
            if index == 0 {
                imageView.isSelected = true
                thumnailImageView.image = image
            }
            
            imageView.updateSelection()

            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 72))
            }
            
            imageView.onTapped { [weak self] in
                self?.thumnailImageView.image = image
                self?.updateThumnailImage(index)
            }
            
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func updateThumnailImage(_ selectedIndex: Int) {
        imageStackView.arrangedSubviews.enumerated().forEach { index, imageView in
            let imageView = imageView as! SelectableImageView
            
            imageView.isSelected = (index == selectedIndex)
            imageView.updateSelection()
        }
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([
            thumnailImageView,
            imageScrollView,
            reSelectPhotoLabel,
            titleTextView
        ])
        
        imageScrollView.addSubview(imageStackView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        thumnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
            $0.size.equalTo(moderateScale(number: 353))
        }
        
        titleTextView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 72))
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(thumnailImageView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 72))
        }
        
        reSelectPhotoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 56))
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
