//
//  KeyboardNumberCell.swift
//  ut-global-ios
//
//  Created by 이범준 on 2023/11/14.
//

import UIKit
import DesignSystem

final class DrinkCell: BaseCollectionViewCell<PairingCellModel> {
    
    static let reuseIdentifer = "DrinkCell"
    
    var cellTapCheck: Bool = false
    
    private lazy var containerView = UIView().then({
        $0.layer.borderColor = DesignSystemAsset.gray500.color.cgColor
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
    })
    
    private lazy var drinkImageView = UIImageView().then({
        $0.image = UIImage(systemName: "circle.fill")
    })
    private lazy var drinkNameLabel = UILabel().then({
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray500.color
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 셀이 재사용될 때 초기화 작업 수행
        cellTapCheck = false
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
            constraints.top.equalToSuperview().offset(moderateScale(number: 15.39))
            constraints.centerX.equalToSuperview()
            constraints.size.equalTo(moderateScale(number: 80))
        }
        drinkNameLabel.snp.makeConstraints { constraints in
            constraints.centerX.equalToSuperview()
            constraints.bottom.equalToSuperview().offset(moderateScale(number: -15.39))
        }
    }
    
    override func bind(_ model: PairingCellModel) {
        super.bind(model)
        print(model)
        drinkNameLabel.text = model.name
    }
    
    func cellIsTapped() {
        if containerView.backgroundColor == DesignSystemAsset.main.color {
            containerView.backgroundColor = .clear
            cellTapCheck = false
        } else {
            containerView.backgroundColor = DesignSystemAsset.main.color
            cellTapCheck = true
        }
    }
}
