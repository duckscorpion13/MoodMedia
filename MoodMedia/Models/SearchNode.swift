//
//  SearchNode.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import Foundation

struct SearchNode: Decodable {
    enum CodingKeys: String, CodingKey { case results }
    let results: [Media]
}
