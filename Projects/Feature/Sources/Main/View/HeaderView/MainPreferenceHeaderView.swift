//
//  MainPreferenceHeaderView.swift
//  Feature
//
//  Created by 이범준 on 3/1/24.
//

import UIKit

final class MainPreferenceHeaderView: UICollectionReusableView {
    
    private lazy var containerView = UIView().then({
        $0.backgroundColor = .white
    })
    
    private lazy var myCouponTitleLabel = UILabel().then({
        $0.text = "내 쿠폰"
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubviews([myCouponTitleLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        myCouponTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupIfNeeded() {
        
    }
    
    func setMyCouponCount(_ count: Int) {
        self.myCouponTitleLabel.text = "내 쿠폰 (" + String(count) + "장)"
    }
}
