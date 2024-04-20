//
//  FeedDetailMenuBottomSheet.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-20.
//

import UIKit
import DesignSystem

final class FeedDetailMenuBottomSheet: UIView {
    // MARK: - Properties
    //
    enum SheetType {
        case someone
        case mine
    }
    // MARK: - Components
    //
    private lazy var backgroundView = TouchableImageView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.4)
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 24)
        $0.clipsToBounds = true
    }
    
    private lazy var editFeedImageView = UIImageView().then {
        $0.image = UIImage(named: "edit_feed")
    }
    
    private lazy var editFeedLabel = UILabel().then {
        $0.text = "게시글 수정하기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
    }
    
    private lazy var editFeedView = UIView()
    
    private lazy var deleteFeedImageView = UIImageView().then {
        $0.image = UIImage(named: "delete_feed")
    }
    
    private lazy var deleteFeedLabel = UILabel().then {
        $0.text = "게시글 삭제하기"
        $0.textColor = DesignSystemAsset.red050.color
        $0.font = Font.medium(size: 16)
    }
    
    private lazy var deleteFeedView = UIView()
    
    private lazy var reportFeedImageView = UIImageView().then {
        $0.image = UIImage(named: "report_feed")
    }
    
    private lazy var reportFeedLabel = UILabel().then {
        $0.text = "신고하기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
    }
    
    private lazy var reportFeedView = UIView()
    
    // MARK: - Initializer
    //
    init(type: SheetType) {
        super.init(frame: UIScreen.main.bounds)
        
        self.addViews(withType: type)
        self.makeConstraints(withType: type)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method

extension FeedDetailMenuBottomSheet {
    public func bind(
        editHandler: (() -> Void)?,
        deleteHandler: (() -> Void)?,
        reportHandler: (() -> Void)?
    ) {
        self.backgroundView.onTapped { [weak self] in
            self?.removeFromSuperview()
        }
        self.editFeedView.onTapped { [weak self] in
            editHandler?()
            self?.removeFromSuperview()
        }
        self.deleteFeedView.onTapped { [weak self] in
            deleteHandler?()
            self?.removeFromSuperview()
        }
        self.reportFeedView.onTapped { [weak self] in
            reportHandler?()
            self?.removeFromSuperview()
        }
    }
    
    private func addViews(withType type: SheetType) {
        switch type {
        case .mine:
            self.editFeedView.addSubviews([
                self.editFeedImageView,
                self.editFeedLabel
            ])
            
            self.deleteFeedView.addSubviews([
                self.deleteFeedImageView,
                self.deleteFeedLabel
            ])
            
            self.containerView.addSubviews([
                self.editFeedView,
                self.deleteFeedView
            ])
        case .someone:
            self.reportFeedView.addSubviews([
                self.reportFeedImageView,
                self.reportFeedLabel
            ])
            
            self.containerView.addSubviews([
                self.reportFeedView
            ])
            
            self.containerView.addSubview(self.reportFeedView)
        }
        
        self.addSubviews([
            backgroundView,
            containerView
        ])
    }
    
    private func makeConstraints(withType type: SheetType) {
        switch type {
        case .mine:
            self.containerView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 10))
                $0.bottom.equalToSuperview().inset(moderateScale(number: 28))
                $0.height.equalTo(moderateScale(number: 116))
            }
            self.editFeedView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(moderateScale(number: 12))
                $0.width.equalToSuperview()
                $0.height.equalTo(moderateScale(number: 44))
            }
            self.deleteFeedView.snp.makeConstraints {
                $0.top.equalTo(editFeedView.snp.bottom)
                $0.width.equalTo(self.editFeedView)
                $0.height.equalTo(self.editFeedView)
            }
            self.editFeedImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(moderateScale(number: 24))
                $0.centerY.equalToSuperview()
                $0.size.equalTo(moderateScale(number: 24))
            }
            self.deleteFeedImageView.snp.makeConstraints {
                $0.leading.equalTo(self.editFeedImageView)
                $0.centerY.equalTo(self.editFeedImageView)
                $0.size.equalTo(self.editFeedImageView)
            }
            self.editFeedLabel.snp.makeConstraints {
                $0.leading.equalTo(self.editFeedImageView.snp.trailing).offset(moderateScale(number: 8))
                $0.centerY.equalToSuperview()
            }
            self.deleteFeedLabel.snp.makeConstraints {
                $0.leading.equalTo(self.deleteFeedImageView.snp.trailing).offset(moderateScale(number: 8))
                $0.centerY.equalToSuperview()
            }
        case .someone:
            self.containerView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 10))
                $0.bottom.equalToSuperview().inset(moderateScale(number: 28))
                $0.height.equalTo(moderateScale(number: 68))
            }
            self.reportFeedView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(moderateScale(number: 12))
                $0.width.equalToSuperview()
                $0.height.equalTo(moderateScale(number: 44))
            }
            self.reportFeedImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(moderateScale(number: 24))
                $0.centerY.equalToSuperview()
                $0.size.equalTo(moderateScale(number: 24))
            }
            self.reportFeedLabel.snp.makeConstraints {
                $0.leading.equalTo(self.reportFeedImageView.snp.trailing).offset(moderateScale(number: 8))
                $0.centerY.equalToSuperview()
            }
        }
    }
}
