//
//  EmitterVC.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/9/17.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit

class EmitterVC: UIViewController {
	var m_emitterLayers = [CAEmitterLayer]()
	
	var currentSummary = ""
	var m_backgroundView: GradientView? = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//		let singleFinger = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(_:)))
//		singleFinger.numberOfTapsRequired = 1
//		singleFinger.numberOfTouchesRequired = 1
//		self.view.addGestureRecognizer(singleFinger)
		let isNight = currentSummary.lowercased().contains("night")
		self.setupBackgroundView(isNight: isNight)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.mapEmitterLayer(currentSummary)
	}
	
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
	
//	@objc func singleTap(_ recognizer: UITapGestureRecognizer) {
//		let point = recognizer.location(ofTouch: 0, in: recognizer.view)
//		let _ = self.emitFirework(point)
//	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
