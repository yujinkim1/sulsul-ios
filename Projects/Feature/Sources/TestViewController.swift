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

// MARK: - baseViewController는 open 접근 제어자
// 이유: https://pikachu987.tistory.com/24
public final class TestViewController: BaseViewController {
    var coordinator: MainCoordinator?
    private lazy var testTouchableView: TouchableView = TouchableView().then({
        $0.backgroundColor = .blue
    })
    public override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.coordinator?.moveTo(appFlow: AppFlow.tabBar(.benefit), userData: nil)
        }
    }
    public override func addViews() {
        view.addSubview(testTouchableView)
    }
    public override func makeConstraints() {
        testTouchableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 100))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    public override func setupIfNeeded() {
        testTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            let vc = TestKeyboardDisappearViewController()
            self?.present(vc, animated: false)
        }
    }
}
