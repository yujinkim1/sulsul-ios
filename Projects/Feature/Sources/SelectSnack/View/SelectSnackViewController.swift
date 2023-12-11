//
//  SelectSnackViewController.swift
//  Feature
//
//  Created by 김유진 on 2023/12/03.
//

import Combine
import DesignSystem
import UIKit

protocol SearchSnack: AnyObject {
    func searchSnackWith(_ searchText: String)
}

public final class SelectSnackViewController: BaseViewController {
    private lazy var viewModel = SelectSnackViewModel()
    private lazy var cancelBag = Set<AnyCancellable>()
    private lazy var snackArray = [Pairing]()
    private lazy var snackSearchArray = [Pairing]()
    private lazy var superViewInset = moderateScale(number: 20)
    
    private lazy var topHeaderView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_backArrow"), for: .normal)
        $0.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
    }
    
    private lazy var noFindSnackButton = UIButton().then {
        $0.setTitle("찾는 안주가 없어요", for: .normal)
        $0.titleLabel?.font = Font.semiBold(size: 14)
        $0.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
    }
    
    private lazy var searchBarView = SearchBarView(delegate: self)
    
    private lazy var questionNumberLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.text = "Q2."
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var snackTitleLabel = UILabel().then {
        $0.font = Font.bold(size: 32)
        $0.text = "함께 먹는 안주"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var selectLimitView = SelectLimitToolTipView()
    
    private lazy var selectedCountLabel = UILabel().then {
        $0.font = Font.medium(size: 14)
        $0.textColor = DesignSystemAsset.gray300.color
        $0.text = "0개 선택됨"
        
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "0개")
        attribtuedString.addAttribute(.font, value: Font.bold(size: 20), range: range)
        $0.attributedText = attribtuedString
    }
    
    private lazy var snackTableView = UITableView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.register(SnackTableViewCell.self, forCellReuseIdentifier: SnackTableViewCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.rowHeight = moderateScale(number: 52)
    }
    
    private lazy var nextButtonBackgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.layer.shadowColor = DesignSystemAsset.black.color.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: -40)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 20
    }
    
    private lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(didTabNextButton), for: .touchUpInside)
        $0.backgroundColor = DesignSystemAsset.gray300.color
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.setTitle("다음", for: .normal)
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color

        addViews()
        makeConstraints()
    }
    
    private func bind() {
        viewModel.snackPublisher().sink { [weak self] snackModel in
            if let snacks = snackModel.pairings {
                self?.snackArray = snacks
                self?.snackSearchArray = snacks
                self?.snackTableView.reloadData()
            }
        }.store(in: &cancelBag)
    }
    
    public override func addViews() {
        view.addSubview(topHeaderView)
        view.addSubview(questionNumberLabel)
        view.addSubview(snackTitleLabel)
        view.addSubview(selectedCountLabel)
        view.addSubview(selectLimitView)
        view.addSubview(searchBarView)
        view.addSubview(snackTableView)
        view.addSubview(nextButtonBackgroundView)
        
        topHeaderView.addSubview(backButton)
        topHeaderView.addSubview(noFindSnackButton)
        nextButtonBackgroundView.addSubview(nextButton)
    }
    
    public override func makeConstraints() {
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
        
        noFindSnackButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(superViewInset)
        }
        
        questionNumberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(topHeaderView.snp.bottom)
        }
        
        snackTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(questionNumberLabel.snp.bottom)
        }
        
        selectedCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(topHeaderView.snp.bottom).offset(moderateScale(number: 36))
        }
        
        selectLimitView.snp.makeConstraints {
            $0.bottom.equalTo(selectedCountLabel.snp.top)
            $0.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 26))
            $0.width.equalTo(moderateScale(number: 108))
        }
        
        searchBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(snackTitleLabel.snp.bottom).offset(moderateScale(number: 32))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        snackTableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButtonBackgroundView.snp.top).offset(moderateScale(number: -25))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(searchBarView.snp.bottom).offset(moderateScale(number: 16))
        }
        
        nextButtonBackgroundView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 89))
            $0.width.bottom.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 50))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc private func didTabBackButton() {
        
    }
    
    @objc private func didTabNoFindSnackButton() {
        
    }
    
    @objc private func didTabNextButton() {
        
    }
}

extension SelectSnackViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snackSearchArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SnackTableViewCell.reuseIdentifier, for: indexPath) as? SnackTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.bind(snack: snackSearchArray[indexPath.row])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if snackSearchArray[indexPath.row].isSelect == true {
            snackSearchArray[indexPath.row].isSelect = false
            
        } else if snackSearchArray.filter({ $0.isSelect == true }).count < 5 {
            snackSearchArray[indexPath.row].isSelect = true
        }
        
        let snackSelectCount = snackSearchArray.filter({ $0.isSelect == true }).count
        let yellowColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
        
        let fullText = "\(snackSelectCount)개 선택됨"
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "\(snackSelectCount)개")
        attribtuedString.addAttribute(.font, value: Font.bold(size: 20), range: range)
        
        selectedCountLabel.attributedText = attribtuedString
        selectedCountLabel.textColor = snackSelectCount > 0 ? yellowColor : DesignSystemAsset.gray300.color
        nextButton.backgroundColor = snackSelectCount > 0 ? yellowColor : DesignSystemAsset.gray300.color
        
        snackTableView.reloadData()
    }
}

extension SelectSnackViewController: SearchSnack {
    func searchSnackWith(_ searchText: String) {
        if searchText == "" {
            snackSearchArray = snackArray
        } else {
            snackSearchArray = snackArray.filter({ $0.name!.contains(searchText) })
            snackSearchArray.indices.forEach { snackSearchArray[$0].highlightedText = searchText }
        }
        
        UIView.transition(with: snackTableView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.snackTableView.reloadData() })
    }
}
