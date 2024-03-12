//
//  CommentModel.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import Foundation

struct CommentModel {
    let commentId: Int
    let userInfo: UserInfo
    let content: String
    let createdAt: Date
    let updatedAt: Date
    let isReported: Bool
    let isWriter: Bool
    let childrenComments: [String]

    enum CodingKeys: String, CodingKey {
      case commentId = "comment_id"
      case userInfo = "user_info"
      case content
      case createdAt = "created_at"
      case updatedAt = "updated_at"
      case isReported = "is_reported"
      case isWriter = "is_writer"
      case childrenComments = "children_comments"
    }
}

// MARK: - UserInfo
struct UserInfo: Decodable {
  let userId: Int
  let nickname: String
  let image: String

  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case nickname
    case image
  }
}
