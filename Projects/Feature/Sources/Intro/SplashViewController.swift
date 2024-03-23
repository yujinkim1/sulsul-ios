//
//  test.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import UIKit
import DesignSystem
import Then
import SnapKit
import Service
import Combine

public final class SplashViewController: BaseViewController {
    var coordinator: MainBaseCoordinator?
    
    private let viewModel: SplashViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "여기 무슨 문구들어갈까\n어쩌구 저쩌구\n술술"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 32)
        $0.numberOfLines = 0
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
            
        viewModel.splashIsCompletedPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if KeychainStore.shared.read(label: "accessToken") != nil {
                    print("로그인되어 있음")
                } else {
                    print("로그인 안되어있음")
                }
                coordinator?.moveTo(appFlow: AppFlow.tabBar(.home(.main)), userData: nil)
            }.store(in: &cancelBag)
    }
    public override func addViews() {
        view.addSubviews([titleLabel])
    }
    
    public override func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(moderateScale(number: 52))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
    }
   
}
