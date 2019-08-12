//
//  Media+.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import Foundation

extension Media {
    var urlForArtwork: URL? {
        guard let artwork = artwork else {
            return nil
        }

        return URL(string: artwork)
    }

    var urlForPreview: URL? {
        guard let previewUrl = previewUrl else {
            return nil
        }

        return URL(string: previewUrl)
    }
}
