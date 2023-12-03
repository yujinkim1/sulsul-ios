//
//  ExampleAPI.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import Foundation

extension APIEndpoint {
    
    enum ExampleAPI {
        case info
        case outBound
        case outBoundList
        case outBoundDetail(String)
        
        var path: String {
            switch self {
            case .info:
                return "example_info"
            case .outBound:
                return "example_outbound"
            case .outBoundList:
                return "example_outbound_list"
            case .outBoundDetail(let id):
                return "example_outbound_detail?transaction_id=\(id)"
            }
        }
    }
}
