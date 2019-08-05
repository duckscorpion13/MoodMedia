//
//  Media+URL.swift
//  itunesapi_cs
//
//  Created by Alejandro Melo Domínguez on 7/27/19.
//  Copyright © 2019 Alejandro Melo Domínguez. All rights reserved.
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
