//
//  ReportViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import UIKit
import SnapKit
import DesignSystem
import Combine

protocol ReportViewControllerDelegate: AnyObject {
    func reportIsComplete()
}

public final class ReportViewController: BaseViewController, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ReportCell.self, indexPath: indexPath) else { return .init() }
        return cell
    }
    
    
    var coordinator: CommonBaseCoordinator?
    var delegate: ReportViewControllerDelegate
    private let viewModel: ReportViewModel
    
    private var cancelBag = Set<AnyCancellable>()
    private var buttonBottomConstraint: Constraint?
    private let textViewPlaceHolder = "텍스트를 입력하세요"
    private let maxTextCount: Int = 100
    private lazy var superViewInset = moderateScale(number: 20)
    
    init(viewModel: ReportViewModel, delegate: ReportViewControllerDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
//    private lazy var reportTableView = UITableView(frame: .zero, style: .plain).then {
//        $0.backgroundColor = DesignSystemAsset.black.color
//        $0.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.reuseIdentifier)
//        $0.delegate = self
//        $0.dataSource = self
//        $0.separatorStyle = .none
//        $0.sectionFooterHeight = 0
//        $0.rowHeight = moderateScale(number: 52)
//    }
    
    private lazy var reportCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then({
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.registerCell(ReportCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
    })
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                  heightDimension: .absolute(moderateScale(number: 18)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(moderateScale(number: 18)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = moderateScale(number: 9)
            
            return section
        }
    }
    
    private lazy var etcReportTextView = UITextView().then({
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.borderColor = DesignSystemAsset.gray400.color.cgColor
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        $0.font = Font.semiBold(size: 16)
        $0.text = textViewPlaceHolder
        $0.textColor = DesignSystemAsset.gray900.color
        $0.isHidden = true
        $0.delegate = self
    })

    private lazy var etcReportLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.text = "- 신고 내용은 자세히 적을수록 좋아요!\n- 허위사실이나 악의적인 목적으로 작성된 내용은 처리되지 않을 수 있습니다."
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = DesignSystemAsset.gray400.color
        $0.isHidden = true
        $0.numberOfLines = 0
    })
    
    public lazy var submitTouchableLabel = IndicatorTouchableView().then {
        $0.text = "다음"
        $0.textColor = DesignSystemAsset.gray200.color
        $0.font = Font.bold(size: 16)
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
        $0.setClickable(false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        self.tabBarController?.setTabBarHidden(true)
        addViews()
        makeConstraints()
        bind()
    }
    
    public override func addViews() {
        super.addViews()
        view.addSubviews([topHeaderView,
                          titleLabel,
                          subTitleLabel,
                          reportCollectionView,
                          etcReportTextView,
                          etcReportLabel,
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
        reportCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
//            $0.height.equalTo(moderateScale(number: 272))
            $0.bottom.equalToSuperview()
        }
        etcReportTextView.snp.makeConstraints {
            $0.top.equalTo(reportCollectionView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 120))
        }
        etcReportLabel.snp.makeConstraints {
            $0.top.equalTo(etcReportTextView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 66))
        }
        submitTouchableLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
            
            let offset = getSafeAreaBottom() + moderateScale(number: 12)
            buttonBottomConstraint = $0.bottom.equalToSuperview().inset(offset).constraint
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlertView(withType: .oneButton,
                                    title: error,
                                    description: error,
                                    submitCompletion: nil,
                                    cancelCompletion: nil)
            }.store(in: &cancelBag)
        
        viewModel.reportSuccessPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.delegate.reportIsComplete()
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancelBag)
        
        viewModel.currentReportContentPublisher()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] content in
                if content.isEmpty {
                    self?.submitTouchableLabel.setClickable(false)
                } else {
                    self?.submitTouchableLabel.setClickable(true)
                }
            }.store(in: &cancelBag)
    }
    
    public override func setupIfNeeded() {
        submitTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            if viewModel.currentReportContentValue() == ReportReason.other.rawValue {
                viewModel.sendCurrentReportContent(etcReportTextView.text)
            }
            viewModel.sendReportContent()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTabBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public override func deinitialize() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] keyboardFrame in
            self?.buttonBottomConstraint?.update(inset: keyboardFrame.height + 10)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] _ in
            self?.buttonBottomConstraint?.update(inset: getSafeAreaBottom() + moderateScale(number: 12))
        }
    }
    
    @objc
    private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

//extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.reportListCount()
//    }
//    
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.reuseIdentifier, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
//        
//        cell.bind(viewModel.getReportList(indexPath.row))
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? ReportTableViewCell {
//            cell.showCellComponent()
//            if indexPath.row == 4 {
//                // MARK: - 그 외 기타사유 클릭시, 나중에 인덱스가 아닌 타입으로 리팩토링 진행 필요
//                etcReportTextView.isHidden = false
//                etcReportLabel.isHidden = false
//            } else {
//                etcReportTextView.isHidden = true
//                etcReportLabel.isHidden = true
//            }
//        }
//        
//        for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
//            if visibleIndexPath != indexPath,
//               let cell = tableView.cellForRow(at: visibleIndexPath) as? ReportTableViewCell {
//                cell.hiddenCellComponet()
//            }
//        }
//
//        viewModel.sendCurrentReportContent(viewModel.getReportList(indexPath.row))
//    }
//}

extension ReportViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = DesignSystemAsset.gray900.color
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = DesignSystemAsset.gray400.color
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= maxTextCount else { return false }

        return true
    }
}
