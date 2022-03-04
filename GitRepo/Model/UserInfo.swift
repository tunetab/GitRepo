//
//  UserInfo.swift
//  GitRepo
//
//  Created by Стажер on 04.03.2022.
//

import Foundation

struct UserInfo: Codable {
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
    }
}
