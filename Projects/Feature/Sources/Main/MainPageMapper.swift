//
//  MainPageMapper.swift
//  Feature
//
//  Created by 이범준 on 3/10/24.
//

import Foundation

struct MainPageMapper {
    func popularFeeds(from remotePopularFeeds: [RemotePopularFeed]) -> [PopularFeed] {
        return remotePopularFeeds.map { feed -> PopularFeed in
            return PopularFeed(feedId: feed.feedId ?? 0,
                               title: feed.title ?? "",
                               content: feed.content ?? "",
                               representImage: feed.representImage ?? "",
                               pairingIds: feed.pairingIds ?? [],
                               images: feed.images ?? [],
                               likeCount: feed.likeCount ?? 0,
                               userId: feed.userId ?? 0,
                               userNickname: feed.userNickname ?? "",
                               userImage: feed.userImage ?? "",
                               createdAt: feed.createdAt ?? "",
                               updatedAt: feed.updatedAt ?? "")
        }
    }
}
