//
//  SingleButtonAlertViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/11/27.
//

import UIKit
import SnapKit
import Then

public final class SingleButtonAlertViewController: UIViewController {
    private var titleText: String?
    private var messageText: String?
    private var contentView: UIView?
    
    private let containerView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = 10
    })
    private lazy var titleLabel = UILabel().then({
        $0.text = titleText
        $0.font = UIFont.setFont(size: 20, family: .Bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var messageLabel = UILabel().then({
        $0.text = messageText
        $0.font = UIFont.setFont(size: 17, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var confirmButton = UIButton().then({
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
    })
    
    convenience init(titleText: String? = nil,
                     messageText: String? = nil) {
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
    }
    
    private func addViews() {
        view.addSubview(containerView)
        view.backgroundColor = .black.withAlphaComponent(0.3)
        containerView.addSubviews([titleLabel,
                                   messageLabel,
                                   confirmButton])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { constraints in
            constraints.centerX.equalToSuperview()
            constraints.centerY.equalToSuperview()
            constraints.height.equalTo(moderateScale(number: 150))
            constraints.trailing.equalToSuperview().offset(moderateScale(number: -20))
            constraints.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        titleLabel.snp.makeConstraints { constraints in
            constraints.top.equalToSuperview().offset(moderateScale(number: 20))
            constraints.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        messageLabel.snp.makeConstraints { constraints in
            constraints.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            constraints.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        confirmButton.snp.makeConstraints { constraints in
            constraints.height.equalTo(moderateScale(number: 48))
            constraints.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            constraints.bottom.equalToSuperview().inset(moderateScale(number: 20))
        }
    }
}

extension SingleButtonAlertViewController {
    @objc func confirmButtonTapped(_ button: UIButton) {
        self.dismiss(animated: false)
    }
}

public final class DoubleButtonAlertViewController: UIViewController {
    private var titleText: String?
    private var messageText: String?
    private var contentView: UIView?
    
    private let containerView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = 10
    })
    private lazy var titleLabel = UILabel().then({
        $0.text = titleText
        $0.font = UIFont.setFont(size: 20, family: .Bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var messageLabel = UILabel().then({
        $0.text = messageText
        $0.font = UIFont.setFont(size: 17, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var nextButton = UIButton().then({
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = DesignSystemAsset.main.color
        $0.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    })
    
    private lazy var cancelButton = UIButton().then({
        $0.setTitle("취소", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    })
    
    convenience init(titleText: String? = nil,
                     messageText: String? = nil) {
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
    }
    
    private func addViews() {
        view.addSubview(containerView)
        view.backgroundColor = .black.withAlphaComponent(0.3)
        containerView.addSubviews([titleLabel,
                                   messageLabel,
                                   nextButton])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { constraints in
            constraints.centerX.equalToSuperview()
            constraints.centerY.equalToSuperview()
            constraints.height.equalTo(moderateScale(number: 150))
            constraints.trailing.equalToSuperview().offset(moderateScale(number: -20))
            constraints.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        titleLabel.snp.makeConstraints { constraints in
            constraints.top.equalToSuperview().offset(moderateScale(number: 20))
            constraints.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        messageLabel.snp.makeConstraints { constraints in
            constraints.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            constraints.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        nextButton.snp.makeConstraints { constraints in
            constraints.height.equalTo(moderateScale(number: 48))
            constraints.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            constraints.bottom.equalToSuperview().inset(moderateScale(number: 20))
        }
    }
}

extension DoubleButtonAlertViewController {
    @objc func nextButtonTapped(_ button: UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc func cancelButtonTapped(_ button: UIButton) {
        self.dismiss(animated: false)
    }
}
