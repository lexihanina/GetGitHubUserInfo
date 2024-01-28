//
//  User.swift
//  JSONParsFromGitHubAPI
//
//  Created by Lexi Hanina on 28.01.24.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let company: String?
    let location: String?
    let hireable: Bool?
    let bio: String?
    let email: String?
    let blog: String?
    let twitterUsername: String?
    let following: Int
    let followers: Int
    let publicRepos: Int
    let createdAt: String
}
