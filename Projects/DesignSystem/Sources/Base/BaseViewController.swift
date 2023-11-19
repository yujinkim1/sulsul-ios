//
//  BaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

public class BaseViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    
    deinit {
        deinitialize()
    }
    
    func addViews() {}
    
    func makeConstraints() {}
    
    func setupIfNeeded() {}
    
    func deinitialize() {}
}
