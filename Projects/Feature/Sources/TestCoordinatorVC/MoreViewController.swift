//
//  MoreViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import UIKit
import DesignSystem

final class MoreViewController: BaseViewController {
    var coordinator: MoreBaseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
