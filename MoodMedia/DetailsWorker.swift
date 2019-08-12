//
//  DetailsWorker.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit

class DetailsWorker {
	let detailsURL = URL(string: "https://itunes.apple.com/lookup?entity=song")!
	
    func fetchAlbumDetails(media: Media, completion: @escaping (_ success: Bool, _ album: Album) -> Void) {
        guard let queryURL = detailsURL(for: media) else {
            completion(false, [])
            return
        }

        ApiClient.get(queryURL.absoluteString, success: { response in
            do {
                let searchNode = try JSONDecoder().decode(AlbumNode.self, from: response)
                completion(true, searchNode.results)
            } catch {
                completion(false, Album())
            }
        }) { error in
            completion(false, Album())
        }
    }
}

extension DetailsWorker {
    func detailsURL(for item: Media) -> URL? {
        guard let collectionId = item.collectionId else {
            return nil
        }

        var urlComponents = URLComponents(url: detailsURL, resolvingAgainstBaseURL: true)!
        let queryId = URLQueryItem(name: "id", value: String(collectionId))

        guard var queryItems = urlComponents.queryItems else {
            urlComponents.queryItems = [queryId]
            return urlComponents.url!
        }

        queryItems.append(queryId)
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}

// MARK: - Response Models (Encodable)
extension DetailsWorker {
    struct AlbumNode: Decodable {
        enum CodingKeys: String, CodingKey { case results }
        let results: [Media]
    }
}
