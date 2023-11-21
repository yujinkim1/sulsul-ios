//
//  DisappearKeyBoardBaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/11/21.
//

import UIKit
import SnapKit
import Then

open class DisappearKeyBoardBaseViewController: BaseViewController {
    
//    var coordinator: AuthBaseCoordinator?
    
    private var submitButtonBottomConstraint: Constraint?
    
    public lazy var submitTouchableLabel = TouchableView().then {
        
        
        $0.backgroundColor = .red
        
    }
    
    open override func addViews() {
        view.addSubviews([submitTouchableLabel])
    }
    
    open override func makeConstraints() {
        submitTouchableLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 48))
            
            let offset = getSafeAreaBottom() + moderateScale(number: 20)
            submitButtonBottomConstraint = $0.bottom.equalToSuperview().inset(offset).constraint
        }
    }
    open override func setupIfNeeded() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    open override func deinitialize() {
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
            self?.submitButtonBottomConstraint?.update(inset: keyboardFrame.height + 20)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { [weak self] _ in
            self?.submitButtonBottomConstraint?.update(inset: getSafeAreaBottom() + moderateScale(number: 20))
        }
    }
}
