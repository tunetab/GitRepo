//
//  RepoDetails.swift
//  GitRepo
//
//  Created by Стажер on 04.03.2022.
//

import Foundation

struct RepoDetails: Codable {
    var html_url: String
    var watchers_count: Int
    var stargazers_count: Int
    var forks_count: Int
    var license: License?
    
    enum CodingKeys: CodingKey {
        case html_url
        case watchers_count
        case stargazers_count
        case forks_count
        case license
    }
}

struct License: Codable {
    var key: String
    var name: String
    var spdx_id: String
    var url: String
    var node_id: String
    
    enum CodingKeys: CodingKey {
        case key
        case name
        case spdx_id
        case url
        case node_id
    }
}
