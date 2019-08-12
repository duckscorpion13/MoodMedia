//
//  SearchInteractor.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
	func startSearch(term: String, page: Int)

    func nextPage(term: String, page: Int)
    func didSelectMedia(media: Media)
}

protocol SearchDataStore {
    var lastTerm: String { get set }
    var currentPage: Int { get set }
    var currentMedias: [Media] { get set }
    var selectedMedia: Media? { get set }
}

protocol SearchPresentationLogic: NSObject {
	func displayResults(medias:  [Media])
	func displayMediaDetails(media: Media)
	func displayLoadingIndicator()
	func dismissLoadingIndicator()
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    weak var presenter: SearchPresentationLogic? = nil
    var worker: SearchWorker? = SearchWorker()


    // MARK: - Data Store
    var lastTerm = ""
    var currentPage: Int = 1
    var currentMedias = [Media]()
    var selectedMedia: Media? = nil

    // MARK: - Business logic

    func startSearch(term: String, page: Int) {
		presenter?.displayLoadingIndicator()

		worker?.fetchMedia(for: term, page: page) { (success, medias) in
			self.presenter?.dismissLoadingIndicator()
			
			if success {
				self.currentMedias = medias
				let response = medias
				self.presenter?.displayResults(medias: response)
			} else {
				
			}
		
        }
    }

    func nextPage(term: String, page: Int) {
        guard term == lastTerm else {
            startSearch(term: term, page: 1)
            return
        }

        currentPage += 1
        lastTerm = term

        worker?.fetchMedia(for: term, page: currentPage) { (success, medias) in
			let filtered = medias.filter { $0.collectionId != nil && $0.kind != nil && $0.kind! == "song" }
			self.currentMedias.append(contentsOf: filtered)
			let response = self.currentMedias

			self.presenter?.displayResults(medias: response)
		}
		
    }

    func didSelectMedia(media: Media) {
        presenter?.displayMediaDetails(media: media)
    }
}
