//
//  KeyboardNumberCell.swift
//  ut-global-ios
//
//  Created by 이범준 on 2023/11/14.
//

import UIKit
import DesignSystem

final class DrinkCell: BaseCollectionViewCell<String> {
    
    static let reuseIdentifer = "DrinkCell"
    
    private lazy var containerView = UIView().then({
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1.0).cgColor
        $0.layer.borderWidth = 1
    })
    
    private lazy var drinkImageView = UIImageView().then({
        $0.image = UIImage(systemName: "circle.fill")
    })
    private lazy var drinkNameLabel = UILabel().then({
        $0.text = "1"
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([drinkImageView,
                                   drinkNameLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { constraints in
            constraints.edges.equalToSuperview()
        }
        drinkImageView.snp.makeConstraints { constraints in
            constraints.centerX.equalToSuperview()
            constraints.centerY.equalToSuperview()
        }
        drinkNameLabel.snp.makeConstraints { constraints in
            constraints.top.equalTo(drinkImageView.snp.bottom)
            constraints.centerX.equalToSuperview()
        }
    }
    
    func setDrinkData(image: String, name: String) {
        print(image)
        print(name)
        drinkNameLabel.text = name
    }
}
