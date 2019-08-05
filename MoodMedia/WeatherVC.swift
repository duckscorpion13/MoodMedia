//
//  ViewController.swift
//  Flat Weather
//
//  Created by Erica Roy on 11/19/14.
//  Copyright (c) 2014 Erica Roy. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class WeatherVC: UIViewController, CLLocationManagerDelegate {
	
	var locationManager = CLLocationManager()
	
    var userLocation : String!
    var userLat : Double!
    var userLong : Double!
    var localCity : String!
    @IBOutlet weak var cityLocationLabel: UILabel!

	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currentSummary: UILabel!
    @IBOutlet weak var ozoneText: UILabel!
    @IBOutlet weak var ozoneLabel: UIView!
  

    
	

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		 //Save for later, put in own function to switch between right now its showing snow
		let emitterLayer = CAEmitterLayer()
		
		emitterLayer.emitterPosition = CGPoint(x: -5, y: 20)
		
		let cell = CAEmitterCell()
		cell.birthRate = 5
		cell.lifetime = 10
		cell.velocity = 50
		cell.scale = 0.05
		
		cell.emissionRange = CGFloat.pi * 2.0
		cell.contents = UIImage(named: "raindrop.png")!.cgImage
		
		emitterLayer.emitterCells = [cell]
		
		view.layer.addSublayer(emitterLayer)
		registerMessage()
		
		initLocation()
		
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.becomeFirstResponder()
	}

	//shake it shake it to get data
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if(event?.subtype == UIEvent.EventSubtype.motionShake){
			
			initLocation()
		   // loadingIndicator.hidden = false
		   // loadingIndicator.startAnimating()
		}
	}
    
	func initLocation(){
		
		//check to see if location services is enabled
		if CLLocationManager .locationServicesEnabled() {
			print("Location Services Enabled")
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.distanceFilter = 1000
			locationManager.requestAlwaysAuthorization()
			locationManager.startUpdatingLocation()
			
		} else {
			print("not enabled")
			let alert = UIAlertController(title: "Location Services Disabled",
				message: "Please enable Location Services",
				preferredStyle: UIAlertController.Style.alert)
				alert.addAction(UIAlertAction(title: "OK",
											  style: UIAlertAction.Style.default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		let location: CLLocation = locations[locations.count-1]

		if (location.horizontalAccuracy > 0) {
			
			self.userLong = (location.coordinate.longitude)
			self.userLat = (location.coordinate.latitude)
			//remove space silly
			self.userLocation = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
			//print(userLocation)
			getCurrentWeatherData(userLocation)
			locationManager.stopUpdatingLocation()

			CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
				
				if error != nil {
					return
				}
				
				if (placemarks?.count)! > 0 {
					let pm = placemarks?[0]
					self.localCity = (pm?.locality)
					self.cityLocationLabel.text = self.localCity
				} else {
					print("Problem with the data received from geocoder")
				}
			})
		}
	}
    

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		let state = CLLocationManager.authorizationStatus()
		if(state == .denied){
			
			let alert = UIAlertController(title: "Denied",
				message: "Permission Denied, please enable location services",
				preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK",
				style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			locationManager.stopUpdatingLocation()
		}

		let alert = UIAlertController(title: "Error", message: "Trouble retrieving location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        locationManager.stopUpdatingLocation()
	}

  

    func getCurrentWeatherData(_ userLocation: String) -> Void
    {
        var skyKey = ""
        //should probably cache this
        
        
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: path!)
        skyKey = keys!.object(forKey: "darkskykey") as! String
        
        let baseURL = URL(string: "https://api.darksky.net/forecast/\(skyKey)/")
        
		guard let forecastURL = URL(string: "\(userLocation)?units=si", relativeTo: baseURL) else {
			return
		}
		
        let task = URLSession.shared.dataTask(with: forecastURL) {
            (data, response, error) in
            
            //if let replace
            guard error == nil else {
                print(error!)
                return
            }
           
            guard let dataObject = data else {
                print("Oops no data")
                return
            }
			
			
			if let info = try? JSONDecoder().decode(ST_DARKSKY_INFO.self, from: dataObject),
			let current = info.currently {
				DispatchQueue.main.async {
					// Update UI
					
					if let temp = current.temperature {
						self.tempLabel.text = "\(Int(temp))ºC"
					}
					
					if let todaySummary = current.summary {
						self.currentSummary.text = "\(todaySummary)"
					}
					
					self.iconView.image = UIImage(named: current.icon ?? "")
					
					let timeInSeconds = TimeInterval(current.time ?? 0)
					let weatherDate = Date(timeIntervalSince1970: timeInSeconds)
					
					let dateFormatter = DateFormatter()
				
					dateFormatter.timeStyle = .full
					dateFormatter.dateFormat = "EEEE"
					
					let dayString = dateFormatter.string(from: weatherDate)
					self.currentTimeLabel.text = dayString
				}
        	}
		}
        task.resume()
     
    }

    
    //end function
    
    
    func registerMessage() {
        
		if #available(iOS 10.0, *) {
			let center = UNUserNotificationCenter.current()
			center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
				// Enable or disable features based on authorization.
				
				if granted {
					print("Granted")
				}else {
					print("No")
				}
				
			}
		} else {
			// Fallback on earlier versions
		}
		
    }
    
    func scheduleMessage() {
        
    }
    
    //Change Background Image depending on temp
    //
    //Add Things to Do according to temp
}



