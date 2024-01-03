//
//  BaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

open class BaseViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        view.backgroundColor = .white
        
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    deinit {
        LogDebug("🌈 deinit ---> \(self)")
        deinitialize()
    }
    
    open func addViews() {}
    
    open func makeConstraints() {}
    
    open func setupIfNeeded() {}
    
    open func deinitialize() {}
}
