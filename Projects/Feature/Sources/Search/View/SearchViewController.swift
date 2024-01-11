//
//  SearchViewController.swift
//  Feature
//
//  Created by 김유진 on 2024/01/10.
//

import UIKit
import DesignSystem

public final class SearchViewController: BaseViewController {
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_leftArrow"), for: .normal)
        $0.setTitle("검색", for: .normal)
        $0.titleLabel?.font = Font.bold(size: 18)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.text = "검색"
    }
    
    private lazy var searchTextField = UITextField().then {
        $0.placeholder = "검색어를 입력해주세요"
        $0.font = Font.bold(size: 32)
    }
    
    private lazy var searchResetButton = UIButton().then {
        $0.setImage(UIImage(named: "search_reset"), for: .normal)
        $0.addTarget(self, action: #selector(didTabsearchResetButton), for: .touchUpInside)
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var recentKeywordTitleLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray700.color
        $0.text = "최근 검색어"
    }
    
    private lazy var recentKeywordResetButton = UIButton().then {
        $0.setTitle("모두 삭제", for: .normal)
        $0.titleLabel?.font = Font.semiBold(size: 14)
        $0.titleLabel?.textColor = DesignSystemAsset.gray700.color
        $0.addTarget(self, action: #selector(didTabRecentKeywordResetButton), for: .touchUpInside)
    }
    
    private lazy var recentKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.register(RecentKeywordCell.self, forCellWithReuseIdentifier: RecentKeywordCell.id)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
    }
    
    public override func addViews() {
        view.addSubviews([
            backButton,
            titleLabel,
            searchTextField,
            searchResetButton,
            lineView,
            recentKeywordTitleLabel,
            recentKeywordResetButton,
            recentKeywordCollectionView
        ])
    }
    
    public override func makeConstraints() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(moderateScale(number: 16))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(moderateScale(number: 28))
            $0.leading.equalTo(backButton)
            $0.trailing.equalTo(searchResetButton.snp.leading).offset(moderateScale(number: -8))
            $0.height.equalTo(moderateScale(number: 40))
        }
        
        searchResetButton.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 32))
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(moderateScale(number: 12))
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 2))
        }
        
        recentKeywordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(moderateScale(number: 21))
            $0.leading.equalTo(backButton)
            $0.height.equalTo(moderateScale(number: 28))
        }
        
        recentKeywordResetButton.snp.makeConstraints {
            $0.trailing.equalTo(searchResetButton)
            $0.centerY.equalTo(recentKeywordTitleLabel)
        }
        
        recentKeywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentKeywordTitleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalTo(backButton)
            $0.trailing.equalTo(searchResetButton)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentKeywordCell.id,
                                                            for: indexPath) as? RecentKeywordCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: moderateScale(number: 40))
    }
}

extension SearchViewController {
    @objc private func didTabRecentKeywordResetButton() {
        
    }
    
    @objc private func didTabsearchResetButton() {
        
    }
}
