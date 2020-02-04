//
//  SecondViewController.swift
//  TryCookies
//
//  Created by Matoria, Ashok on 03/02/20.
//  Copyright © 2020 Matoria, Ashok. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var launchButton: UIButton!
    
    @IBAction func touchLaunchButton(_ sender: Any) {
        let consumeCookieHybridVC = ConsumeCookieHybridViewController()
        navigationController?.pushViewController(consumeCookieHybridVC, animated: true)
    }
}
