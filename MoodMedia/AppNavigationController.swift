//
//  AppNavigationController.swift
//  itunesapi_cs
//
//  Created by Alejandro Melo Domínguez on 7/29/19.
//  Copyright © 2019 Alejandro Melo Domínguez. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var interfaceOrientation: UIInterfaceOrientation {
        return .portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViewController()
    }

    func setupInitialViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC {
//        setViewControllers([viewController], animated: false)
			setViewControllers([vc], animated: true)
		}
    }
}
