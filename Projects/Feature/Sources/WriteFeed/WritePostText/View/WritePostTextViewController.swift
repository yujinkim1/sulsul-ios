//
//  WritePostTextViewController.swift
//  Feature
//
//  Created by 김유진 on 2/15/24.
//

import UIKit
import DesignSystem

final class WritePostTextViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderText("썸네일&제목입력", actionText: "다음")
    }
    
    override func addViews() {
        super.addViews()
    }
    
    override func makeConstraints() {
        super.makeConstraints()
    }
}
