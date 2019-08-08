//
//  DetailVC.swift
//  itunesapi_cs
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 Alejandro Melo Domínguez. All rights reserved.
//
import AVKit
import UIKit

struct DetailsModel {
	let artistName: String
	let albumName: String
	var albumCoverImage: URL?
	let tracks: [Media]
}

protocol DetailsDisplayLogic: class {
	func displayDataForAlbum(viewModel: DetailsModel)
	func routeToMediaPlayer(media: Media)
}


class DetailVC: UIViewController, DetailsDisplayLogic, DetailsPresentationLogic {

	
		let cellIdentifier = "DetailsTableViewCell"
		var interactor: DetailsInteractor? = nil
	
		let m_tableView = UITableView(frame: .zero)
		let m_imageView = UIImageView(frame: .zero)
		let m_artistLbl = UILabel(frame: .zero)
		let m_albumLbl = UILabel(frame: .zero)
		
		var album: Album? = nil
		var tracks: [Media] = []
		
		// MARK: Object lifecycle
		
		override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
			super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
			setup()
		}
		
		required init?(coder aDecoder: NSCoder) {
			super.init(coder: aDecoder)
			setup()
			
		}
		
		// MARK: Setup
		
		private func setup() {
			self.interactor = DetailsInteractor()
			if let interactor = self.interactor {
				interactor.presenter = self
			}
//			let interactor = DetailsInteractor()
//			let presenter = DetailsPresenter()
//			let router = DetailsRouter()
//			self.interactor = interactor
//			self.router = router
//			interactor.presenter = presenter
//			presenter.viewController = self
//			router.viewController = self
//			router.dataStore = interactor
		}
		
	
		
		// MARK: View lifecycle
		
		override func viewDidLoad() {
			super.viewDidLoad()
	
			m_tableView.delegate = self
			m_tableView.dataSource = self
			
//			m_tableView.register(MyTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
			m_tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
			
			self.view.addSubview(m_tableView)
			m_tableView.full(of: view)
			
			let headView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
			headView.backgroundColor = .red
			headView.addSubview(m_imageView)
			m_imageView.anchor(top: headView.topAnchor, left: headView.leftAnchor, bottom: nil, right: nil, width: 100, height: 100, paddingTop: 8, paddingLeft: 8)
			
	
			//		m_artistLbl.numberOfLines = 0
			headView.addSubview(m_artistLbl)
			m_artistLbl.anchor(top: m_imageView.topAnchor, left: m_imageView.rightAnchor, bottom: nil, right: headView.rightAnchor, width: nil, height: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8)
			m_albumLbl.numberOfLines = 3
			headView.addSubview(m_albumLbl)
			m_albumLbl.anchor(top: m_artistLbl.bottomAnchor, left: m_artistLbl.leftAnchor, bottom: nil, right: headView.rightAnchor, width: nil, height: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 8)
			
			if let dataStore = interactor,
			let media = dataStore.media {
				interactor?.fetchAlbumDetails(request: media)
			}
			
			m_tableView.tableHeaderView = headView
		}
		
		// MARK: Use cases
		func displayDataForAlbum(viewModel: DetailsModel) {
			title = viewModel.albumName
			m_artistLbl.text = viewModel.artistName
			m_albumLbl.text = viewModel.albumName
			
			m_imageView.sd_cancelCurrentImageLoad()
			m_imageView.image = nil
			
			if let artworkUrl = viewModel.albumCoverImage {
				m_imageView.sd_setImage(with: artworkUrl)
			}
			
			tracks = viewModel.tracks
			m_tableView.reloadData()
		}
	
		func presentAlbumDetails(response: [Media]) {
			var viewModel = DetailsModel(
				artistName: response.albumInfo?.artistName ?? "",
				albumName: response.albumInfo?.collectionName ?? "",
				albumCoverImage: nil,
				tracks: response.tracks
			)
			
			if let artworkUrl = response.albumInfo?.urlForArtwork {
				viewModel.albumCoverImage = artworkUrl
			}
			
			self.displayDataForAlbum(viewModel: viewModel)
		}
		func presentAlbumDetailsErrorMessage() {
			
		}
		func presentMediaPlayer(response: Media) {
//			self.routeToMediaPlayer(media: response)
		}
	
		func routeToMediaPlayer(media: Media) {
			
		}
	}
	
	// MARK: - UITableView
	
	extension DetailVC: UITableViewDataSource {
		// MARK: Data source
		
		func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return tracks.count
		}
		
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) //as! MyTableViewCell
	
			let item = tracks[indexPath.row]
			
			cell.textLabel?.text = "\(item.trackNumber ?? 0)  \(item.trackName ?? "")"
//			cell.nameLabel.text = item.trackName
//			cell.detailLabel.text = "\(item.trackNumber ?? 0)"
			
			return cell
		}
	}
	
	extension DetailVC: UITableViewDelegate {
		
		// MARK: Delegate
		
		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			tableView.deselectRow(at: indexPath, animated: true)
			
			let track = tracks[indexPath.row]
			//        let request = Details.Request(media: track)
			
			if let urlStr = track.previewUrl,
				let url = URL(string: urlStr) {
				let player = AVPlayer(url: url)
				let playerViewController = AVPlayerViewController()
				playerViewController.player = player
				player.play()
				self.present(playerViewController, animated: true, completion: nil)
				
			}
			//        interactor?.didSelectMedia(request: request)
		}
}
