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
            imageScrollView
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
    }
}
