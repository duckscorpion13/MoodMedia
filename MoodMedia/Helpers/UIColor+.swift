//
//  UIColor+.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/7.
//  Copyright © 2019 DKY. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
		self.init(r, g, b, 1)
	}
	
	convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {
		let red = r / 255.0
		let green = g / 255.0
		let blue = b / 255.0
		self.init(red: red, green: green, blue: blue, alpha: a)
	}
	
	class var lightskyblue: UIColor {
		return UIColor(0x87, 0xCE, 0xFA)
	}
	
	class var lightblue: UIColor {
		return UIColor(0xAD, 0xD8, 0xE6)
	}
	
	class var lavender: UIColor {
		return UIColor(0xE6, 0xE6, 0xFA)
	}
	
}
