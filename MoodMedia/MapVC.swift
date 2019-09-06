//
//  MapVC.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/9/2.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate {
	var locationManager = CLLocationManager()
	
	var m_position: CLLocationCoordinate2D!
	
	lazy var m_mapView: MKMapView = {
		return MKMapView()
	}()
	
	let m_btnsView = BtnsView()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupMapView()
		
		initLocation()
		
		setupBtns()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		locationManager.startUpdatingLocation()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		locationManager.stopUpdatingLocation()
	}
	
	func setupMapView() {
		self.view.addSubview(self.m_mapView)
		self.view.sendSubviewToBack(self.m_mapView)
		self.m_mapView.full(of: self.view)
		self.m_mapView.mapType = .satellite
		self.m_mapView.delegate = self
		self.m_mapView.showsUserLocation = true
		self.m_mapView.userTrackingMode = .follow
	}
	
	func setupBtns() {
		self.m_btnsView.delegate = self
		self.view.addSubview(self.m_btnsView)
		self.view.bringSubviewToFront(self.m_btnsView)
		self.m_btnsView.translatesAutoresizingMaskIntoConstraints = false
		self.m_btnsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.m_btnsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
		self.m_btnsView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
		self.m_btnsView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
	}
	
	func initLocation(){
		
		//check to see if location services is enabled
		if CLLocationManager.locationServicesEnabled() {
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
		self.m_position = location.coordinate
		
		if (location.horizontalAccuracy > 0) {
			setupMapData(location.coordinate)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapVC: MKMapViewDelegate {
	func drawRoute(_ destination: CLLocationCoordinate2D) {
		self.m_mapView.removeOverlays(self.m_mapView.overlays)
		
		let sourceLocation = self.m_position!
	
		let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
		let destinationPlacemark = MKPlacemark(coordinate: destination, addressDictionary: nil)
		
		// 4.
		let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
		let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
		
		// 5.
		let sourceAnnotation = MKPointAnnotation()
		sourceAnnotation.title = "Times Square"
		
		if let location = sourcePlacemark.location {
			sourceAnnotation.coordinate = location.coordinate
		}
		
		
		let destinationAnnotation = MKPointAnnotation()
		destinationAnnotation.title = "Empire State Building"
		
		if let location = destinationPlacemark.location {
			destinationAnnotation.coordinate = location.coordinate
		}
		
		// 6.
		self.m_mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
		
		// 7.
		let directionRequest = MKDirections.Request()
		directionRequest.source = sourceMapItem
		directionRequest.destination = destinationMapItem
		directionRequest.transportType = .automobile
		
		// 计算方向
		let directions = MKDirections(request: directionRequest)
		
		// 8.
		directions.calculate {
			(response, error) -> Void in
			
			guard let response = response else {
				if let error = error {
					print("Error: \(error)")
				}
				
				return
			}
			
			for route in response.routes {
				self.m_mapView.addOverlay((route.polyline), level: .aboveRoads)
				
				let rect = route.polyline.boundingMapRect
				self.m_mapView.setRegion(MKCoordinateRegion(rect), animated: true)
			}
		}
	}
	func setupMapData(_ coordinate: CLLocationCoordinate2D) {

		if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//			self.m_mapView.removeOverlays(self.m_mapView.overlays)
			self.m_mapView.removeAnnotations(self.m_mapView.annotations)
			
			let title = "You"
			
			let latDelta = 0.01
			let longDelta = 0.01
			let currentLocationSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
			
			let currentRegion = MKCoordinateRegion(center: coordinate, span: currentLocationSpan)
			self.m_mapView.setRegion(currentRegion, animated: true)
			
			let regionRadius = 300.0
			
			let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: title)
			locationManager.startMonitoring(for: region)
			
		
			
			let myAnnotation = MKPointAnnotation()
			myAnnotation.coordinate = coordinate;
			myAnnotation.title = "\(title)";
			self.m_mapView.addAnnotation(myAnnotation)
			
//			let circle = MKCircle(center: coordinate, radius: regionRadius)
//			self.m_mapView.addOverlay(circle)
		} else {
			print("System can't track regions")
		}
	}
	
	func  mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//		let circleRenderer = MKCircleRenderer(overlay: overlay)
		let circleRenderer = MKPolylineRenderer(overlay: overlay)
		circleRenderer.strokeColor = UIColor.red
		circleRenderer.lineWidth = 1.0
		return circleRenderer
	}
	
	fileprivate func searchPlace(_ query: String) {
		let searchRequest = MKLocalSearch.Request()
		searchRequest.region = self.m_mapView.region
		searchRequest.naturalLanguageQuery = query
		let search = MKLocalSearch(request: searchRequest)
		search.start { response, error in
			guard let response = response else {
				print("Error: \(error?.localizedDescription ?? "Unknown error").")
				return
			}
			
			for anno in self.m_mapView.annotations {
				if(anno.title != "You") {
					self.m_mapView.removeAnnotation(anno)
				}
			}
			
			var places = [Place]()
			for item in response.mapItems {
				print(item.phoneNumber ?? "No phone number.")
				let place = Place(isCurrentLocation: item.isCurrentLocation,
								  name: item.name,
								  url: item.url,
								  phoneNumber: item.phoneNumber,
								  latitude: item.placemark.coordinate.latitude,
								  longitude: item.placemark.coordinate.longitude)
				places.append(place)
				
				let annotation = MKPointAnnotation()
				annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude:  place.longitude)
				annotation.title =  place.name ?? ""
				self.m_mapView.addAnnotation(annotation)
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if let coordinate = view.annotation?.coordinate {
			self.drawRoute(coordinate)
		}
	}
}

extension MapVC: BtnsViewDelegate {
	func btnsViewClickCafe() {
		self.searchPlace("cafe")
	}
	
	func btnsViewClickFood() {
		self.searchPlace("food")
	}
	
	func btnsViewClickShop() {
		self.searchPlace("shop")
	}
}
