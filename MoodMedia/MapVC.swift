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
	
	lazy var m_mapView: MKMapView = {
		return MKMapView()
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupMapView()
		
		initLocation()
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
	func setupData(_ coordinate: CLLocationCoordinate2D) {
		// 1. 檢查系統是否能夠監視 region
		if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
			self.m_mapView.removeOverlays(self.m_mapView.overlays)
			self.m_mapView.removeAnnotations(self.m_mapView.annotations)
			// 2.準備 region 會用到的相關屬性
			let title = "Lorrenzillo's"
			
			let latDelta = 0.01
			let longDelta = 0.01
			let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
			
			// 設置地圖顯示的範圍與中心點座標
			
			let currentRegion:MKCoordinateRegion =
				MKCoordinateRegion(
					center: coordinate,
					span: currentLocationSpan)
			self.m_mapView.setRegion(currentRegion, animated: true)
			
			let regionRadius = 300.0
			
			// 3. 設置 region 的相關屬性
			let region = CLCircularRegion(center: coordinate, radius: regionRadius, identifier: title)
			locationManager.startMonitoring(for: region)
			
			// 4. 創建大頭釘(annotation)
			let restaurantAnnotation = MKPointAnnotation()
			restaurantAnnotation.coordinate = coordinate;
			restaurantAnnotation.title = "\(title)";
			self.m_mapView.addAnnotation(restaurantAnnotation)
			
			// 5. 繪製一個圓圈圖形（用於表示 region 的範圍）
			let circle = MKCircle(center: coordinate, radius: regionRadius)
			self.m_mapView.addOverlay(circle)
		}
		else {
			print("System can't track regions")
		}
	}
	
	// 6. 繪製圓圈
	func  mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let circleRenderer = MKCircleRenderer(overlay: overlay)
		circleRenderer.strokeColor = UIColor.red
		circleRenderer.lineWidth = 1.0
		return circleRenderer
	}
}
