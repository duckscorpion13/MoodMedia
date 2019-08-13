//
//  Gradient.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

enum EN_GRADIENT_TYPE: Int {
	case GRADIENT_LEFTUP_TO_RIGHTDOWN
	case GRADIENT_UP_TO_DOWN
	case GRADIENT_LEFT_TO_RIGHT
}

class GradientView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	
	convenience init(frame: CGRect, colors: [UIColor], type: EN_GRADIENT_TYPE, isRoundCorner: Bool = false) {
		self.init(frame: frame)
		
		if(isRoundCorner) {
			self.clipsToBounds = true
			self.layer.cornerRadius = frame.height / 2
		}
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = frame
		switch type {
			case .GRADIENT_UP_TO_DOWN:
				gradientLayer.startPoint = CGPoint(x: 0, y: 0)
				gradientLayer.endPoint = CGPoint(x: 0, y: 1)
			case .GRADIENT_LEFT_TO_RIGHT:
				gradientLayer.startPoint = CGPoint(x: 0, y: 0)
				gradientLayer.endPoint = CGPoint(x: 1, y: 0)
			default:
				gradientLayer.startPoint = CGPoint(x: 0, y: 0)
				gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		}
		
		gradientLayer.colors = colors.map({return $0.cgColor})
		self.layer.addSublayer(gradientLayer)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension CAGradientLayer {
	convenience init(startColor: UIColor, endColor: UIColor, type: EN_GRADIENT_TYPE = .GRADIENT_LEFTUP_TO_RIGHTDOWN) {
		self.init()
		
		switch type {
		case .GRADIENT_UP_TO_DOWN:
			self.startPoint = CGPoint(x: 0, y: 0)
			self.endPoint = CGPoint(x: 0, y: 1)
		case .GRADIENT_LEFT_TO_RIGHT:
			self.startPoint = CGPoint(x: 0, y: 0)
			self.endPoint = CGPoint(x: 1, y: 0)
		default:
			self.startPoint = CGPoint(x: 0, y: 0)
			self.endPoint = CGPoint(x: 1, y: 1)
		}
		
		self.colors = [startColor.cgColor, endColor.cgColor]
	}
}
