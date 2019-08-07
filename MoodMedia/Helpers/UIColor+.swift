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
	
	class var skyblue: UIColor {
		return UIColor(135, 206, 235)
	}
	
}
