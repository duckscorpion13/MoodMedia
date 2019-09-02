//
//  WeatherVC.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications


class WeatherVC: MapVC {
	
    var userLocation : String!

    var localCity : String!
    @IBOutlet weak var cityLocationLabel: UILabel!

	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var currentTimeLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var currentSummary: UILabel!

	
	var m_backgroundView: GradientView? = nil
	
	var m_searchStr = ""
    
	var m_emitterLayers = [CAEmitterLayer]()

	func setupBackgroundView(isNight: Bool) {
		if let bgv = self.m_backgroundView {
			bgv.removeFromSuperview()
		}
		let color1 = isNight ? UIColor.blue : UIColor.lightskyblue
		let color2 = isNight ? UIColor.black : UIColor.lavender
		let bgv = GradientView(frame: self.view.frame, colors: [color1, color2], type: .GRADIENT_LEFTUP_TO_RIGHTDOWN)
		self.view.addSubview(bgv)
		bgv.full(of: self.view)
		
		self.view.sendSubviewToBack(bgv)
		self.m_backgroundView = bgv
	}
	
	
	
	fileprivate func setupTestBtn() {
		let btn = UIButton(frame: .zero)
		btn.setTitle("Promote Music", for: .normal)
		btn.addTarget(self, action: #selector(self.clickTest1(_:)), for: .touchDown)
	
		self.view.addSubview(btn)
		self.view.bringSubviewToFront(btn)
		
		btn.backgroundColor = .orange
		
		btn.clipsToBounds = true
		btn.layer.cornerRadius = 25
		
		btn.translatesAutoresizingMaskIntoConstraints = false
		if #available(iOS 11.0, *) {
			btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
		} else {
			btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
		}
		btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		btn.widthAnchor.constraint(equalToConstant: 150).isActive = true
		btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	@objc func clickTest1(_ sender: UIButton) {
		self.navigationController?.pushViewController(SearchVC(self.m_searchStr), animated: true)
		sender.tag += 1
	}
	
	
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		setupTestBtn()
		
		let singleFinger = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:)))
		singleFinger.numberOfTapsRequired = 1
		singleFinger.numberOfTouchesRequired = 1
		self.view.addGestureRecognizer(singleFinger)
	}
	@objc func singleTap(_ recognizer: UITapGestureRecognizer) {
		let point = recognizer.location(ofTouch: 0, in: recognizer.view)
		let _ = self.emitFirework(point)
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	
	override func viewWillAppear(_ animated: Bool) {
		locationManager.startUpdatingLocation()
		self.navigationController?.isNavigationBarHidden = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.becomeFirstResponder()
	}

	//shake it shake it to get data
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if(event?.subtype == UIEvent.EventSubtype.motionShake){
			initLocation()
		}
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
					
					if let summary = current.summary {
						self.currentSummary.text = "\(summary)"
						self.mapEmitterLayer(summary)
					}
					
					if let icon = current.icon {
						self.m_searchStr = icon
						self.iconView.image = UIImage(named: icon)
						
//						let isNight = icon.lowercased().contains("night")
//						self.setupBackgroundView(isNight: isNight)
//						self.view.backgroundColor = icon.lowercased().contains("night") ? .blue : .skyblue
					}
					//					let hour = Calendar.current.component(.hour, from: weatherDate)
					//					self.view.backgroundColor = hour>17 ? .blue : .skyblue
										
					let timeInSeconds = TimeInterval(current.time ?? 0)
					let weatherDate = Date(timeIntervalSince1970: timeInSeconds)
					
					let dateFormatter = DateFormatter()
				
					dateFormatter.timeStyle = .full
					dateFormatter.dateFormat = "M/d EE HH:mm"
					
					let dayString = dateFormatter.string(from: weatherDate)
					self.currentTimeLabel.text = dayString
					
				}
        	}
		}
        task.resume()
     
    }   

	override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		super.locationManager(manager, didUpdateLocations: locations)
		
		let location: CLLocation = locations[locations.count-1]
		
		if (location.horizontalAccuracy > 0) {
			//remove space silly
			self.userLocation = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
			//print(userLocation)
			getCurrentWeatherData(userLocation)
			setupData(location.coordinate)
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
	
}

extension WeatherVC {
	func flameCell(scale: CGFloat = 0.25) -> CAEmitterCell {
		let cell = CAEmitterCell()
		
		cell.color = UIColor(red: 1, green: 0.5, blue: 0.2, alpha: 1.0).cgColor
		cell.contents = UIImage(named: "spark")?.cgImage
		cell.scale = scale
		
		cell.lifetime = 5.0
		cell.birthRate = 150
		cell.alphaSpeed = -0.4
		cell.velocity = 50
		cell.velocityRange = 50
		cell.emissionRange = CGFloat.pi * 2
		
		return cell
	}
	
	func emitSunThorn() -> CAEmitterLayer {
		let emitterLayer = CAEmitterLayer()
		emitterLayer.emitterPosition = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
		emitterLayer.emitterShape = .circle
		emitterLayer.emitterMode = .outline
		emitterLayer.emitterSize = CGSize(width: 100, height: 100)
		emitterLayer.renderMode = .oldestLast
		
		let cell = CAEmitterCell()
		cell.contents = UIImage(named: "spark")?.cgImage
		cell.scale = 0.1
		cell.alphaRange = 0.2
		cell.alphaSpeed = -0.8
		cell.birthRate = 1000
		cell.lifetime = 1
		cell.velocity = 150
		cell.velocityRange = 10
		cell.color = UIColor.orange.cgColor
		
		emitterLayer.emitterCells = [cell]
		self.view.layer.addSublayer(emitterLayer)
		
		return emitterLayer
	}
	
	private func trailCell() -> CAEmitterCell {
		let cell = CAEmitterCell()
		
		cell.contents = UIImage(named: "raindrop")?.cgImage
		cell.lifetime = 0.5
		cell.birthRate = 45
		cell.velocity = 80
		cell.scale = 0.1
		cell.alphaSpeed = -0.7
		cell.scaleSpeed = -0.1
		cell.scaleRange = 0.1
		cell.beginTime = 0.01
		cell.duration = 1.7
		cell.emissionRange = CGFloat.pi / 8
		cell.emissionLongitude = CGFloat.pi * 2
		cell.yAcceleration = -350
		
		return cell
	}
	
	private func flakeCell(_ img: String, scale: CGFloat, birthRate: Float) -> CAEmitterCell {
		let cell = CAEmitterCell()
		
		cell.color = UIColor.white.cgColor
		cell.contents = UIImage(named: img)?.cgImage
		cell.lifetime = 5.5
		
		cell.birthRate = birthRate
		
		cell.blueRange = 0.15
		cell.alphaRange = 0.4
		cell.velocity = 50
		cell.velocityRange = 300
		cell.scale = scale
		cell.scaleRange = scale / 2
		//		cell.emissionRange = CGFloat.pi / 2
		cell.emissionLongitude = CGFloat.pi
		cell.yAcceleration = 100
		cell.scaleSpeed =  -scale * 0.2
		
		cell.alphaSpeed = -0.1
		cell.spin = CGFloat(Double.pi/2)
		cell.spinRange = CGFloat(Double.pi/2 / 2)
		
		return cell
	}
	
	func emitSnow() -> CAEmitterLayer {
		return addParticle("snow", birthRate: 30)
	}
	
	func emitDrizzle() -> CAEmitterLayer {
		return addParticle("raindrop", birthRate: 15)
	}
	
	func emitRain() -> CAEmitterLayer {
		//Save for later, put in own function to switch between right now its showing snow
		
		let emitterLayer = CAEmitterLayer()
		emitterLayer.emitterPosition = CGPoint(x: 0, y: 0)
		emitterLayer.emitterMode = .outline
		emitterLayer.emitterShape = .line
		emitterLayer.emitterSize = CGSize(width: self.view.bounds.size.width * 2, height: 0)
		
		let cell = CAEmitterCell()
		cell.birthRate = 50
		cell.lifetime = 10
		cell.velocity = 80
		cell.yAcceleration = 150
		cell.scale = 0.2
		
		//		cell.emissionRange = CGFloat.pi * 2
		//		cell.emissionLatitude = CGFloat.pi / 2
		cell.emissionLongitude = CGFloat.pi
		cell.contents = UIImage(named: "RainParticle")?.cgImage
		
		emitterLayer.emitterCells = [cell]
		
		view.layer.addSublayer(emitterLayer)
		
		return emitterLayer
	}
	
	func fireworkCell() -> CAEmitterCell {
		let cell = CAEmitterCell()
		
		cell.contents = UIImage(named: "spark")?.cgImage
		cell.lifetime = 10
		cell.birthRate = 1000
		cell.velocity = 130
		cell.scale = 0.2
		cell.spin = 2
		cell.alphaSpeed = -0.2
		cell.scaleSpeed = -0.1
		cell.beginTime = 1.5
		cell.duration = 0.1
		cell.emissionRange = CGFloat.pi * 2
		cell.yAcceleration = -80
		
		return cell
	}
	func emitFirework(_ startPoint: CGPoint) -> CAEmitterLayer {
		
		let emitterLayer = CAEmitterLayer()
		
		emitterLayer.emitterSize = CGSize(width: view.bounds.width, height: view.bounds.height)
		
		emitterLayer.emitterPosition = startPoint//CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 1.5)
		
		emitterLayer.renderMode = .additive
		
		let cell = CAEmitterCell()
		cell.color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5).cgColor
		cell.redRange = 0.9
		cell.greenRange = 0.9
		cell.blueRange = 0.9
		cell.lifetime = 2.5
		cell.birthRate = 5
		cell.velocity = 300
		cell.velocityRange = 100
		cell.emissionRange = CGFloat.pi / 4
		cell.emissionLongitude = CGFloat.pi * 3 / 2
		cell.yAcceleration = 100
		
		cell.emitterCells = [trailCell(), fireworkCell()]
		
		emitterLayer.emitterCells = [cell]
		
		view.layer.addSublayer(emitterLayer)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			emitterLayer.lifetime = 0
		}
		
		return emitterLayer
	}
	
	func addParticle(_ img: String, birthRate: Float, pos: CGPoint = CGPoint(x: 0, y: 0)) -> CAEmitterLayer {
		//""冰花"" 產生CAEmitterLayer()跟CAEmitterCell()的元件
		let emitterLayer = CAEmitterLayer()
		
		emitterLayer.emitterSize = CGSize(width: view.bounds.width * 2, height: 0)
		//發射起點
		emitterLayer.emitterPosition = pos
		//粒子從具有相對角的矩形發射
		//		emitterLayer.renderMode = .additive
		
		emitterLayer.emitterShape = .line
		emitterLayer.emitterMode = .outline
		
		let cell = flakeCell(img, scale: 0.1, birthRate: birthRate)
		
		emitterLayer.emitterCells = [cell]
		view.layer.addSublayer(emitterLayer)
		
		return emitterLayer
		
	}
	
	func emitCloud() -> CAEmitterLayer  {
		let emitterLayer = CAEmitterLayer()
		
		emitterLayer.emitterSize = CGSize(width: view.bounds.width * 2, height: 0)
		//發射起點
		emitterLayer.emitterPosition = CGPoint(x: 0, y: view.bounds.height / 3)
		//粒子從具有相對角的矩形發射
		emitterLayer.renderMode = .additive
		
		emitterLayer.emitterShape = .point
		emitterLayer.emitterMode = .surface
		
		
		let cell = CAEmitterCell()
		cell.contents = UIImage(named: "cloudy")?.cgImage
		cell.birthRate = 0.5
		cell.alphaRange = 0.5
		cell.lifetime = 20
		cell.velocity = 10
		
		cell.xAcceleration = 5
		cell.emissionRange = CGFloat.pi / 2
		
		cell.scale = 0.30
		cell.scaleRange = 0.1
		emitterLayer.emitterCells = [cell]
		view.layer.addSublayer(emitterLayer)
		
		return emitterLayer
	}
	
	func mapEmitterLayer(_ descption: String) {
		for layer in self.m_emitterLayers {
			layer.removeFromSuperlayer()
		}
		
		if descption.lowercased().contains("rain") {
			self.m_emitterLayers.append(self.emitRain())
		}
		
		if descption.lowercased().contains("drizzle") {
			self.m_emitterLayers.append(self.emitDrizzle())
		}
		
		if descption.lowercased().contains("clear") {
			self.m_emitterLayers.append(self.emitSunThorn())
		}
		
		if descption.lowercased().contains("cloud") {
			self.m_emitterLayers.append(self.emitCloud())
		}
		
		if descption.lowercased().contains("snow") {
			self.m_emitterLayers.append(self.emitSnow())
		}
		
//		if descption.lowercased().contains("wind") {
//			self.m_emitterLayers.append(self.emitFirework())
//		}
	}
}


