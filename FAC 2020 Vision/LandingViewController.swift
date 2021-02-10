//
//  ViewController.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-10.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

	@IBOutlet weak var backgroundImage: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			UIView.animate(withDuration: 1.5, animations: {
				self.backgroundImage.alpha = 0.0
			}) { (bool) in
				self.performSegue(withIdentifier: "segue", sender: nil)
			}
			
		}
	}

	
	override func viewDidLayoutSubviews() {
		
	}
}

