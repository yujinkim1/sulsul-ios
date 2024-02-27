//
//  BaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

open class BaseViewController: UIViewController {
    open lazy var keyboardHeight: CGFloat = 0

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = DesignSystemAsset.black.color
        navigationController?.navigationBar.isHidden = true
        
        addViews()
        makeConstraints()
        setupIfNeeded()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
    }
    
    deinit {
        LogDebug("🌈 deinit ---> \(self)")
        deinitialize()
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.keyboardHeight = keyboardHeight
        }
    }
    
    open func addViews() {}
    
    open func makeConstraints() {}
    
    open func setupIfNeeded() {}
    
    open func deinitialize() {}
    
    open func showAlertView(withType type: AlertType,
                       title: String,
                       description: String?,
                       submitCompletion: (() -> Void)?,
                       cancelCompletion: (() -> Void)?) {
        let alertView = AlertView(alertType: type)
        alertView.bind(title: title, description: description, submitCompletion: submitCompletion, cancelCompletion: cancelCompletion)
        
        view.addSubview(alertView)
        view.bringSubviewToFront(alertView)
    }
    
    open func showToastMessageView(toastType: ToastType, title: String) {
        let toastView = ToastMessageView()
        toastView.bind(toastType: toastType, title: title)
        
        view.addSubview(toastView)
        view.bringSubviewToFront(toastView)
        toastView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(keyboardHeight + moderateScale(number: 15))
        }
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut, animations: { [weak self] in
            toastView.alpha = 0.0
        }, completion: { [weak self] _ in
            toastView.removeFromSuperview()
        })
    }
    
    open func showBottomSheetAlertView(bottomSheetAlertType: BottomSheetAlertType, title: String, description: String?, submitCompletion: (() -> Void)?,
                                       cancelCompletion: (() -> Void)?) {
        let bottomSheetAlertView = BottomSheetAlertView(bottomSheetAlertType: bottomSheetAlertType)
        bottomSheetAlertView.bind(title: title,
                                  description: description,
                                  submitCompletion: submitCompletion,
                                  cancelCompletion: cancelCompletion)
        view.addSubview(bottomSheetAlertView)
        view.bringSubviewToFront(bottomSheetAlertView)
    }
    
    open func showCameraBottomSheet(selectCameraCompletion: (() -> Void)?, selectAlbumCompletion: (() -> Void)?, baseCompletion: (() -> Void)?) {
        let cameraBottomSheet = CameraBottomSheet()
        cameraBottomSheet.bind(selectCameraCompletion: selectCameraCompletion,
                               selectAlbumCompletion: selectAlbumCompletion,
                               selectBaseCompletion: baseCompletion)
        view.addSubview(cameraBottomSheet)
        view.bringSubviewToFront(cameraBottomSheet)
    }
}
