//
//  PostClass.swift
//  TablePostApp
//
//  Created by 1 on 12.11.2021.
//

import Foundation



// MARK: - Posts
struct Posts: Codable {
    let posts: [Post]
}

// MARK: - Post
struct Post: Codable {
    let postID, timeshamp: Int
    let title, previewText: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}

struct PostId: Codable {
    let post: PostCurrent
}

// MARK: - Post
struct PostCurrent: Codable {
    let postID, timeshamp: Int
    let title, text: String
    let images: [String]
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title, text, images
        case likesCount = "likes_count"
    }
}
