//
//  TapGestureRecognizer.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

final class TapGestureRecognizer: UITapGestureRecognizer {
    var onTapped: (() -> Void)?
    var opTappedPosition: ((CGPoint) -> Void)?
}
