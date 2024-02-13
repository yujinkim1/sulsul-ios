//
//  WriteFeedPhotoCell.swift
//  Feature
//
//  Created by 김유진 on 2/6/24.
//

import UIKit
import DesignSystem

final class WriteFeedPhotoCell: BaseCollectionViewCell<UIImage> {
    
    private lazy var photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var selectedNumberLabel = UILabel().then {
        $0.layer.borderWidth = moderateScale(number: 1.5)
        $0.layer.borderColor = DesignSystemAsset.black.color.cgColor
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.3)
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layout()
    }
    
    override func bind(_ model: UIImage) {
        photoImageView.image = model
    }
    
    private func layout() {
        addSubview(photoImageView)
        addSubview(selectedNumberLabel)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectedNumberLabel.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 16))
            $0.top.trailing.equalToSuperview().inset(moderateScale(number: 4))
        }
    }
}
