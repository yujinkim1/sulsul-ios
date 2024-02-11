//
//  FeedModel.swift
//  Feature
//
//  Created by 이범준 on 2/11/24.
//

import Foundation

struct FeedModel {
    let nextCursorId: Int
    let size: Int
    let isLast: Bool
    let content: [Feed]
}

struct Feed {
    let feedId: Int
    let writerInfo: WriterInfo
    let title: String
    let content: String
    let representImage: String
    let images: [String]
    let alcoholPairingIds: [Int]
    let foodPairingIds: [Int]
    let isLiked: Bool
    let viewCount: Int
    let likesCount: Int
    let commentsCount: Int
    let score: Int
    let createdAt: String
    let updatedAt: String
}

struct WriterInfo {
    let userId: Int
    let nickname: String
    let image: String
}
