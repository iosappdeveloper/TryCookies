//
//  FirstViewController.swift
//  TryCookies
//
//  Created by Matoria, Ashok on 03/02/20.
//  Copyright © 2020 Matoria, Ashok. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var launchButton: UIButton!
    
    @IBAction func tapLaunchButton(_ sender: Any) {
        UserDefaults.standard.clearCookies()
        
        let createCookiesVC = CreateCookieHybridViewController()
        navigationController?.pushViewController(createCookiesVC, animated: true)
    }
}
