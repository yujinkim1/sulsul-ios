//
//  TransactionHistoryBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import Foundation

public protocol TransferHistoryBaseCoordinator: Coordinator {}

protocol TransferHistoryBaseCoordinated {
    var coordinator: TransferHistoryBaseCoordinator? { get }
}
