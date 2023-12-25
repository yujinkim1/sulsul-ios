//
//  ReportViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import UIKit
import DesignSystem

public class ReportViewController: BaseViewController {
    
    private let viewModel: ReportViewModel = ReportViewModel()
    
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
        $0.text = "신고 사유가 무엇일까요?"
    })
    
    private lazy var reportTableView = UITableView(frame: .zero, style: .grouped).then {
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

    }
    
    public override func makeConstraints() {
        super.makeConstraints()
    }
    
    @objc private func didTabBackButton() {
        
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportListCount()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SnackTableViewCell.reuseIdentifier, for: indexPath) as? SnackTableViewCell else { return UITableViewCell() }
//        
//        cell.selectionStyle = .none
//        cell.bind(snack: viewModel.snackSectionModel(in: indexPath.section).cellModels[indexPath.row])
//        
//        return cell
//    }
    
}
