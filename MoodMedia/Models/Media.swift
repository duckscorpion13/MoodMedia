//
//  Media.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import Foundation

struct Media: Codable {
    let wrapperType: String
    let artistName: String

    let collectionId: Int?
    let collectionName: String?

    let kind: String?
    let trackId: Int?
    let trackName: String?
    let trackNumber: Int?

    var artwork: String?
    var previewUrl: String?
}

extension Media {
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind, trackName, trackNumber, artistName, collectionId, collectionName, previewUrl, trackId
        case artwork = "artworkUrl100"
    }
}

