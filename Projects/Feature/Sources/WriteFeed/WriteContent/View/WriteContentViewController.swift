//
//  WriteContentViewController.swift
//  Feature
//
//  Created by 김유진 on 2/19/24.
//

import UIKit
import DesignSystem

final class WriteContentViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator?
    private lazy var images: [UIImage] = []
    
    private lazy var imageScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
        $0.layoutMargins = UIEdgeInsets(top: 0, left: moderateScale(number: 20), bottom: 0, right: moderateScale(number: 20))
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var recognizedTitleLabel = UILabel().then {
        $0.text = "인식된 술&안주"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    }
    
    private lazy var recognizedContentLabel = UILabel().then {
        $0.text = "AI가 열심히 찾고있어요!"
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.medium(size: 16)
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var recognizedImageView = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_progress")
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 16)
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.font = Font.medium(size: 16)
        $0.delegate = self
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var placeholderLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray300.color
        $0.text = "내용을 입력해주세요.\n#를 눌러 태그를 추가할 수 있어요."
    }
    
    private lazy var tagContainerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderText("내용입력", actionText: "게시", actionColor: DesignSystemAsset.gray300.color)
    }
    
    func setSelectedImages(_ images: [UIImage]) {
        self.images = images
        
        images.enumerated().forEach { index, image in
            let imageView = DeletableImageView(image: image)
            
            if index == 0 {
                imageView.setDisplayDeleteIcon(true)
            }

            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 98))
            }
            
            imageStackView.addArrangedSubview(imageView)
            
            imageView.onTapped { [weak self] in
                self?.images.removeAll(where: { $0 == image })
                imageView.removeFromSuperview()
            }
        }
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([
            imageScrollView,
            recognizedTitleLabel,
            recognizedContentLabel,
            recognizedImageView,
            lineView,
            contentStackView,
            placeholderLabel
        ])
        
        contentStackView.addArrangedSubviews([
            contentTextView,
            tagContainerView
        ])
        
        imageScrollView.addSubview(imageStackView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 98))
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        recognizedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        recognizedImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalTo(recognizedTitleLabel)
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        recognizedContentLabel.snp.makeConstraints {
            $0.leading.equalTo(recognizedTitleLabel.snp.trailing).offset(moderateScale(number: 5))
            $0.trailing.equalTo(recognizedImageView.snp.leading).offset(moderateScale(number: -5))
            $0.centerY.equalTo(recognizedImageView)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(recognizedTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 10))
            $0.width.centerX.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentTextView).offset(moderateScale(number: 7))
        }
    }
}

extension WriteContentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
