//
//  ReportViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import UIKit
import SnapKit
import DesignSystem

public class ReportViewController: BaseViewController {
    
    private let viewModel: ReportViewModel = ReportViewModel()
    
    var buttonBottomConstraint: Constraint?
    private lazy var superViewInset = moderateScale(number: 20)
    
    private lazy var topHeaderView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_backArrow"), for: .normal)
        $0.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.bold(size: 32)
        $0.text = "신고하기"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private let subTitleLabel = UILabel().then({
        $0.font = Font.medium(size: 18)
        $0.text = "신고 사유가 무엇일까요?"
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var reportTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.sectionFooterHeight = 0
        $0.rowHeight = moderateScale(number: 52)
    }
    
    public lazy var submitTouchableLabel = IndicatorTouchableView().then {
        $0.text = "다음"
        $0.textColor = DesignSystemAsset.gray200.color
        $0.font = Font.bold(size: 16)
        $0.backgroundColor = DesignSystemAsset.main.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
//        $0.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        super.addViews()
        view.addSubviews([topHeaderView,
                          titleLabel,
                          subTitleLabel,
                          reportTableView,
                          submitTouchableLabel])
        topHeaderView.addSubview(backButton)
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        reportTableView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.bottom.equalTo(submitTouchableLabel.snp.top).offset(moderateScale(number: -16))
        }
        submitTouchableLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
            
            let offset = getSafeAreaBottom() + moderateScale(number: 12)
            buttonBottomConstraint = $0.bottom.equalToSuperview().inset(offset).constraint
        }
    }
    
    @objc private func didTabBackButton() {
        
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportListCount()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.reuseIdentifier, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        
        cell.bind(viewModel.getReportList(indexPath.row))
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ReportTableViewCell {
            cell.showCellComponent()
        }
        
        for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
            if visibleIndexPath != indexPath,
               let cell = tableView.cellForRow(at: visibleIndexPath) as? ReportTableViewCell {
                cell.hiddenCellComponet()
            }
        }
        
        // 선택된 셀 뷰모델에 저장하고 있다가 제출 누르면 서버 전송되도록
    }
}
