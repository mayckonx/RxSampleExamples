//
//  RepositoryGit.swift
//  Example1
//
//  Created by Mayckon Barbosa da Silva on 8/30/18.
//  Copyright © 2018 Mayckon Barbosa da Silva. All rights reserved.
//

import ObjectMapper

class RepositoryGit: Mappable {
    var identifier: Int!
    var language: String!
    var url: String!
    var name: String!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
