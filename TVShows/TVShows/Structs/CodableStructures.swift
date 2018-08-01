//
//  User.swift
//  TVShows
//
//  Created by Infinum Student Academy on 19/07/2018.
//  Copyright © 2018 Juraj Radanovic. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}
struct LoginData: Codable {
    let token: String
}

struct Show: Codable{
    let title: String
    let id: String
    let imageUrl: String
    let likesCount: Int?
    enum CodingKeys: String, CodingKey{
        case title
        case id = "_id"
        case imageUrl
        case likesCount
    }
}

struct ShowDetails: Codable{
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int?
    let imageUrl: String
    enum CodingKeys: String, CodingKey{
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
    }
}

struct Episode: Codable{
    let id: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String

    let imageUrl: String
    enum CodingKeys: String, CodingKey{
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}

struct EpisodeDetails: Codable{
    let showId: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    let type: String
    let id: String
    let imageUrl: String
    enum CodingKeys: String, CodingKey{
        case showId
        case title
        case description
        case episodeNumber
        case season
        case type
        case id = "_id"
        case imageUrl
    }
}

struct newEpisode: Codable{
    let showId: String
    let mediaId: String?
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    enum CodingKeys: String, CodingKey{
        case showId
        case mediaId
        case title
        case description
        case episodeNumber
        case season
    }
}

struct Media: Codable {
    let path: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case path
        case type
        case id = "_id"
    }
}

struct Comment: Codable {
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
}
