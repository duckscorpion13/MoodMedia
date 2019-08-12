//
//  SearchVC.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit
import SDWebImage

class SearchVC: UIViewController, SearchPresentationLogic {
	let contentCellIdentifier = "SearchTableViewCell"
	
	var interactor = SearchInteractor()
	
	var m_medias = [Media]()
	
	var m_searchStr = ""
	
	let m_tableView = UITableView(frame: .zero)
	private weak var noResultsLabel: UILabel?
	
	let m_searchCtl = UISearchController(searchResultsController: nil)
	weak var activityIndicator: UIActivityIndicatorView?
	
	// MARK: Object lifecycle
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
	}
	
	// MARK: Setup
	convenience init(_ search: String) {
		self.init()
		self.m_searchStr = search
	}

	
	
	// MARK: View lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		m_tableView.dataSource = self
		m_tableView.delegate = self
		m_tableView.register(MyTableViewCell.self, forCellReuseIdentifier: contentCellIdentifier)
		view.addSubview(m_tableView)
		m_tableView.full(of: view)
		
		setupSearchController()
		

		interactor.presenter = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = false
		if("" != self.m_searchStr) {
			interactor.startSearch(term: self.m_searchStr, page: 1)
			self.title = self.m_searchStr
			self.m_searchStr = ""
		}
	}
	
	func displayResults(medias: [Media]) {
		m_medias = medias
		m_tableView.reloadData()
		
		if medias.isEmpty {
			displayNoResults()
		} else {
			self.m_tableView.beginUpdates()
			self.m_tableView.setContentOffset(.zero, animated: true)
			self.m_tableView.endUpdates()
		}
	}
	
	func displayNoResults() {
		m_medias = []
		hideNoResults()
		
		let message = UILabel(frame: view.bounds)
		message.backgroundColor = .white
		message.textColor = .darkGray
		message.text = "No hay resultados."
		message.textAlignment = .center
		
		view.addSubview(message)
		view.bringSubviewToFront(message)
		
		noResultsLabel = message
	}
	
	
	func hideNoResults() {
		noResultsLabel?.removeFromSuperview()
	}
	
	func displayLoadingIndicator() {
		let indicator = UIActivityIndicatorView()
		indicator.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		indicator.hidesWhenStopped = true
		indicator.clipsToBounds = true
		indicator.layer.cornerRadius = 8.0
		
		m_searchCtl.searchBar.isUserInteractionEnabled = false
		view.isUserInteractionEnabled = false
		
		view.addSubview(indicator)
		view.bringSubviewToFront(indicator)
		
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
		indicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
		indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		activityIndicator = indicator
		activityIndicator?.startAnimating()
	}
	
	func dismissLoadingIndicator() {
		activityIndicator?.stopAnimating()
		activityIndicator?.removeFromSuperview()
		
		m_searchCtl.searchBar.isUserInteractionEnabled = true
		view.isUserInteractionEnabled = true
	}
	
	func displayMediaDetails(media: Media) {
//		router?.routeToDetails()
		let vc = DetailVC()
		vc.interactor?.media = media
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

// MARK: - UITableView

extension SearchVC: UITableViewDataSource {
	
	
	// MARK: Data source
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return m_medias.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let abstractCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: contentCellIdentifier, for: indexPath)
		
		if let cell = abstractCell as? MyTableViewCell {
			let media = m_medias[indexPath.row]
			if let artworkUrl = media.urlForArtwork {
				cell.imgView.sd_setImage(with: artworkUrl)
			}
			
			cell.nameLabel.text = media.trackName
			cell.detailLabel.text = media.artistName
		}
		
		return abstractCell
	}
}

extension SearchVC: UITableViewDelegate {
	// MARK: Delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let media = m_medias[indexPath.row]
//		let request = Search.DetailsRequest(media: media)
		interactor.didSelectMedia(media: media)
	}
}


extension SearchVC {
	func setupSearchController() {
//		let attributes = [
//			NSAttributedString.Key.foregroundColor: UIColor.white
//		]
//
//		let appearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
//		appearance.setTitleTextAttributes(attributes, for: .normal)
		
		m_searchCtl.searchBar.placeholder = "Nombre de la canción"
//		searchController.obscuresBackgroundDuringPresentation = false
		m_searchCtl.searchBar.barStyle = .black
		m_searchCtl.searchBar.barTintColor = .white
		m_searchCtl.searchBar.delegate = self
		
//		navigationItem.searchController = searchController
//		navigationItem.hidesSearchBarWhenScrolling = false
		
		definesPresentationContext = false
		
		m_tableView.tableHeaderView = m_searchCtl.searchBar
//		navigationItem.titleView =  searchController.searchBar
	}
}

extension SearchVC: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let term = searchBar.text?.lowercased() else {
			return
		}
		
		m_tableView.reloadData()
		hideNoResults()
		
//		let request = Search.Request(searchTerm: term, page: 1)
		interactor.startSearch(term: term, page: 1)
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
	
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		m_medias = []
		
		m_tableView.reloadData()
		hideNoResults()
	}
}
