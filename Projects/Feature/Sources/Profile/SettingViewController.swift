//
//  SettingViewController.swift
//  Feature
//
//  Created by 이범준 on 12/31/23.
//

import UIKit
import DesignSystem

public final class SettingViewController: BaseViewController {
    var coordinator: MoreBaseCoordinator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private lazy var topHeaderView = UIView()
    
    private lazy var containerView = UIView()
    
    private lazy var managementTitleLabel = UILabel()
    
    private lazy var managementStackView = UIStackView()
    
    private lazy var appSettingTitleLabel = UILabel()
    
    private lazy var appSettingStackView = UIStackView()
}
