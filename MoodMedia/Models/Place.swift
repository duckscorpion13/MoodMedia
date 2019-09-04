//
//  Place.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/9/4.
//  Copyright © 2019 DKY. All rights reserved.
//

import Foundation

struct Place: Codable {
	let isCurrentLocation: Bool
	let name: String?
	
	let url: URL?
	let phoneNumber: String?
	
	let latitude: Double	
	let longitude: Double
}
