//
//  CarouselCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import UIKit
import DesignSystem

final class CarouselCell: BaseCollectionViewCell<Feed> {
    static let reuseIdentifier = "CarouselCell"
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage()
        $0.contentMode = .scaleToFill
    }
    
    private lazy var opaqueView = UIView().then {
        $0.frame = .zero
        $0.layer.shadowColor = DesignSystemAsset.black.color.cgColor
        $0.layer.shadowOpacity = Float(0.2)
        $0.layer.shadowOffset = .zero
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = CGFloat(20)
        self.layer.borderColor = .none
        self.layer.borderWidth = .zero
        self.layer.masksToBounds = true
        
        self.backgroundView = imageView
        
        addViews()
        makeConstraints()
    }
    
    // MARK: - Custom Method
    
    func configure(_ image: String) {
        if let imageURL = URL(string: image) {
            imageView.loadImage(imageURL)
        } else {
            print("Image URL is not available.")
            imageView.image = UIImage()
        }
    }
    
    private func addViews() {
        contentView.addSubviews([
            imageView,
            opaqueView
        ])
        contentView.sendSubviewToBack(imageView)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        opaqueView.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
    }
}
