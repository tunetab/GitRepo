//
//  ReadMe.swift
//  GitRepo
//
//  Created by Стажер on 05.03.2022.
//

import Foundation

struct ReadMe: Codable {
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case content
    }
}
