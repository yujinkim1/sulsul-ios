//
//  Endpoint.swift
//  Service
//
//  Created by 이범준 on 2023/11/20.
//

import Foundation
import Alamofire

protocol Endpoint {
    var baseURLString: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
}

extension Endpoint {
    var url: String {
        return baseURLString + path
    }
}
