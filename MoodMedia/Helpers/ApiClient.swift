//
//  ApiClient.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

//import Alamofire
import Foundation

class ApiClient {
	static func get(_ path: String, success: @escaping (Data) -> Void, failure: @escaping (Error?) -> Void) {
		guard let url = URL(string: path) else {
			return
		}
		URLCache.shared.removeAllCachedResponses()
		let task = URLSession.shared.dataTask(with: url)  {
			(data, response, error) in
			guard let _data = data, error == nil else {
				failure(error)
				return
			}
			DispatchQueue.main.async {
				success(_data)
			}			
		}
		task.resume()
	}
}
