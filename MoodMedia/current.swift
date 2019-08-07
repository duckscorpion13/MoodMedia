//
//  current.swift
//  Flat Weather
//
//  Created by Erica Roy on 03/23/18.
//  Copyright (c) 2018 Erica Roy. All rights reserved.
//

import Foundation
import UIKit

struct ST_DARKSKY_DATA: Codable {	//SI
	let time: Int?
	let summary: String?
	let icon: String?
	let sunriseTime: Int?
	let sunsetTime: Int?
	let moonPhase: Double?
	let nearestStormDistance: Double?		//	km
	let precipIntensity: Double?	//	m/hr
	let precipIntensityMax: Double?	//	m/hr
	let precipAccumulation: Double?	//	mm
	let precipIntensityError: Double?	
	let precipProbability: Double?
	let precipType: String?
	
	let temperature: Double?	//	ºC
	
	let temperatureHigh: Double?	//	ºC
	let temperatureHighTime: Int?
	
	let temperatureLow: Double?	//	ºC
	let temperatureLowTime: Int?
	
	let temperatureMin: Double?	//	ºC
	let apparentTemperatureMinTime: Int?
	
	let temperatureMax: Double?	//	ºC
	let apparentTemperatureMaxTime: Int?
	
	let apparentTemperature: Double?	//	ºC
	
	let dewPoint: Double?	//	ºC
	let humidity: Double?
	let pressure: Double?
	let windSpeed: Double?	//	m/sec
	let windGust: Double?	//	m/sec
	let windBearing: Int?
	let cloudCover: Double?
	let uvIndex: Int?
	let visibility: Double?	//	km
	let ozone: Double?
}

struct ST_DARKSKY_INTERVAL: Codable {
	let summary: String?
	let icon: String?
	let data: [ST_DARKSKY_DATA]?
}

struct ST_DARKSKY_INFO: Codable {
	let latitude: Double?
	let longitude: Double?
	let timezone: String?
	let currently: ST_DARKSKY_DATA?
	let minutely: ST_DARKSKY_INTERVAL?
	let hourly: ST_DARKSKY_INTERVAL?
	let daily: ST_DARKSKY_INTERVAL?
}

struct Current {
    
    var currentTime : String?
    var temperature: Float?
	var currentAlert : String?
    var icon: UIImage?
    var ozone: Float?
    var uvindex: Int?
    var todaySummary: String?

    init(weatherDictionary: NSDictionary){
			
        let currentWeather: NSDictionary = weatherDictionary["currently"] as! NSDictionary
		_ = weatherDictionary["daily"] as! NSDictionary
		
        temperature = currentWeather["temperature"] as? Float
        ozone = currentWeather["ozone"] as? Float
        uvindex = currentWeather["uvIndex"] as? Int
        todaySummary = currentWeather["summary"] as? String
		
        //icon = currentWeather["icon"] as String
        let currentTimeIntValue = currentWeather["time"] as! Int
        currentTime = dateStringFromUnixTime(unixTime: currentTimeIntValue)
        let iconString = currentWeather["icon"] as! String
        icon = weatherIconFromString(stringIcon: iconString)
    }
	
	func dateStringFromUnixTime(unixTime: Int) -> String{
	
		let timeInSeconds = TimeInterval(unixTime)
		let weatherDate = Date(timeIntervalSince1970: timeInSeconds)
		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .short

		return dateFormatter.string(from: weatherDate)
	}
    func dayStringFromUnixTime(unixTime: Int) -> String{
        
        let timeInSeconds = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSeconds)
		
        let format = DateFormatter()
		
        format.timeStyle = .full
        format.dateFormat = "EEEE"
		
        return format.string(from: weatherDate)
    }
    
	
	//this is setting the icon from the weather pulled from the dictionary
    
	func weatherIconFromString(stringIcon: String) -> UIImage {
		//setup variable to pull the string from the return
		var imageName: String
		//setup case for the return stuff to pull the image from our folder
		switch stringIcon
		{
		case "clear-day":
			imageName = "clear"
		case "clear-night":
			imageName = "nt_clear"
		case "rain":
			imageName = "rain"
		case "snow":
			imageName = "snow"
		case "sleet":
			imageName = "sleet"
		case "wind":
			imageName = "wind"
		case "fog":
			imageName = "fog"
		case "cloudy":
			imageName = "cloudy"
		case "partly-cloudy-day":
			imageName = "partlycloudy"
		case "partly-cloudy-night":
			imageName = "nt_partlycloudy"
		default:
			imageName = "default"
		
		
		
		}
		//set another variable
		
		let iconName = UIImage(named: imageName)
		return iconName!
	}

}
