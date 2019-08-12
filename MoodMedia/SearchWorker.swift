//
//  SearchWorker.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit

class SearchWorker {
	let searchURL = URL(string: "https://itunes.apple.com/search?media=all")!
	let resultsPerPage = 20
	
	
    func fetchMedia(
        for term: String,
        page: Int,
        completion: @escaping ((_ success: Bool, _ medias: [Media]) -> Void)
    ) {
        let queryURL = searchURL(for: term, page: page)

        ApiClient.get(queryURL.absoluteString, success: { response in
            do {
                let searchNode = try JSONDecoder().decode(SearchNode.self, from: response)
                completion(true, searchNode.results)
            } catch {
                completion(false, [Media]())
            }
        }) { error in
            completion(false, [Media]())
        }
    }
}

extension SearchWorker {
    func searchURL(for term: String, page: Int = 1) -> URL {
        var urlComponents = URLComponents(url: searchURL, resolvingAgainstBaseURL: false)!

        guard var queryItems = urlComponents.queryItems else {
            let termItem = URLQueryItem(name: "term", value: term)
            let pageItem = URLQueryItem(name: "offset", value: String((page - 1) * resultsPerPage))

            urlComponents.queryItems = [termItem, pageItem]
            return urlComponents.url!
        }

        let termItem = URLQueryItem(name: "term", value: term)
        let pageItem = URLQueryItem(name: "offset", value: String((page - 1) * resultsPerPage))

        queryItems.append(contentsOf: [termItem, pageItem])
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}
