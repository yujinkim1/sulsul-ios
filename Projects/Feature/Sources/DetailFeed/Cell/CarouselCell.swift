//
//  CarouselCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import UIKit
import DesignSystem

final class CarouselCell: UICollectionViewCell {
    static let reuseIdentifier = "CarouselCell"
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private lazy var blendView = UIView().then {
        $0.frame = .zero
        $0.layer.backgroundColor = DesignSystemAsset.black.color.cgColor.copy(alpha: 0.2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = CGFloat(20)
        self.layer.borderColor = .none
        self.layer.borderWidth = .zero
        self.layer.masksToBounds = true
        
        self.backgroundView = imageView
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(withURL imageURL: String) {
        if let image = URL(string: imageURL) {
            self.imageView.loadImage(image)
        } else {
            self.imageView.image = UIImage()
            debugPrint("Image URL is not available.")
        }
    }
    
    private func addViews() {
        self.addSubview(imageView)
        self.contentView.addSubview(blendView)
    }
    
    private func makeConstraints() {
        self.blendView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
