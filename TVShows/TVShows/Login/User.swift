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
    let likesCount: Int?
    enum CodingKeys: String, CodingKey{
        case title
        case id = "_id"
        case likesCount
    }
}
