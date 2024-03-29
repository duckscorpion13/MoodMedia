//
//  BtnsView.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/6/28.
//  Copyright © 2019 DKY. All rights reserved.

import UIKit

import UIKit

@objc protocol BtnsViewDelegate {
	@objc optional func btnsViewClickCafe()
	@objc optional func btnsViewClickFood()
	@objc optional func btnsViewClickShop()
	@objc optional func btnsViewClickMusic()
}

class BtnsView: UIView {
	
	weak var delegate: BtnsViewDelegate? = nil

	let m_stackView: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		stack.alignment = .center
		stack.spacing = 25
		return stack
	}()
	
	let m_cafeBtn : UIButton = {
		let btn = UIButton()
		btn.setBackgroundImage(UIImage(named: "cafe"), for: .normal)
//		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.addTarget(self, action: #selector(handleCafe), for: .touchUpInside)
		return btn
	}()
	
	@objc fileprivate func handleCafe() {
		resetAlpha()
		self.m_cafeBtn.alpha = 1
		delegate?.btnsViewClickCafe?()
	}
	
	let m_foodBtn : UIButton = {
		let btn = UIButton()
		btn.setBackgroundImage(UIImage(named: "food"), for: .normal)
//		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.addTarget(self, action: #selector(handleFood), for: .touchUpInside)
		return btn
	}()
	
	@objc fileprivate func handleFood() {
		resetAlpha()
		self.m_foodBtn.alpha = 1
		delegate?.btnsViewClickFood?()
	}
	
	let m_shopBtn : UIButton = {
		let btn = UIButton()
		btn.setBackgroundImage(UIImage(named: "shop"), for: .normal)
//		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.addTarget(self, action: #selector(handleShop), for: .touchUpInside)
		return btn
	}()
	
	@objc fileprivate func handleShop() {
		resetAlpha()
		self.m_shopBtn.alpha = 1
		delegate?.btnsViewClickShop?()
	}
	
	let m_musicBtn : UIButton = {
		let btn = UIButton()
		btn.setBackgroundImage(UIImage(named: "music"), for: .normal)
//		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.addTarget(self, action: #selector(handleMusic), for: .touchUpInside)
		return btn
	}()
	
	@objc fileprivate func handleMusic() {
		resetAlpha()
		self.m_musicBtn.alpha = 1
		delegate?.btnsViewClickMusic?()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		translatesAutoresizingMaskIntoConstraints = false
	
		m_stackView.addArrangedSubview(m_cafeBtn)
		m_stackView.addArrangedSubview(m_shopBtn)
		m_stackView.addArrangedSubview(m_foodBtn)
		m_stackView.addArrangedSubview(m_musicBtn)
		addSubview(m_stackView)
		m_stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		m_stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		m_stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		m_stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		resetAlpha()
	}
	
	fileprivate func resetAlpha() {
		for view in self.m_stackView.subviews {
			if let btn = view as? UIButton {
				btn.alpha = 0.5
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
}

