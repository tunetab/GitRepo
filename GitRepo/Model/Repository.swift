//
//  Repository.swift
//  GitRepo
//
//  Created by Стажер on 01.03.2022.
//

import Foundation

struct Repo: Codable {
    var id: Int
    var name: String
    var description: String?
    var language: String?
    var owner: UserInfo

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case language
        case owner
    }

}
