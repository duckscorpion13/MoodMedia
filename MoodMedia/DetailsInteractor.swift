//
//  DetailsInteractor.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit

protocol DetailsBusinessLogic {
    func fetchAlbumDetails(request: Media)
    func didSelectMedia(request: Media)
}

protocol DetailsDataStore {
    var media: Media? { get set }
    var album: Album? { get set }
}

protocol DetailsPresentationLogic: NSObject {
	func presentAlbumDetails(response: [Media])
	func presentAlbumDetailsErrorMessage()
	func presentMediaPlayer(response: Media)
}

class DetailsInteractor: DetailsBusinessLogic, DetailsDataStore {
    weak var presenter: DetailsPresentationLogic? = nil
    var worker = DetailsWorker()
    var media: Media?
    var album: Album?

    // MARK: Do something

    func fetchAlbumDetails(request: Media) {
        worker.fetchAlbumDetails(media: request, completion: { success, album in
            self.album = album

            if success {
                self.presenter?.presentAlbumDetails(response: album)
            } else {
                self.presenter?.presentAlbumDetailsErrorMessage()
            }
        })
    }

    func didSelectMedia(request: Media) {
        presenter?.presentMediaPlayer(response: request)
    }
}
