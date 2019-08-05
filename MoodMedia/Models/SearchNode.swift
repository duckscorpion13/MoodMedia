//
//  SearchNode.swift
//  itunesapi_cs
//
//  Created by Alejandro Melo Domínguez on 7/27/19.
//  Copyright © 2019 Alejandro Melo Domínguez. All rights reserved.
//

import Foundation

struct SearchNode: Decodable {
    enum CodingKeys: String, CodingKey { case results }
    let results: [Media]
}
