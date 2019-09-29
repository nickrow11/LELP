//
//  ViewController.swift
//  Application
//
//  Created by Admin on 9/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var LightsButton: UIButton!
    @IBOutlet weak var PowerButton: UIButton!
    @IBOutlet weak var AudioButton: UIButton!
    @IBOutlet weak var VibrateButton: UIButton!
    @IBOutlet weak var TempButton: UIButton!
    @IBOutlet weak var BatteryButton: UIButton!
    @IBOutlet weak var TitleBar: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        PowerButton.layer.cornerRadius = 10
        LightsButton.layer.cornerRadius = 10
        AudioButton.layer.cornerRadius = 10
        VibrateButton.layer.cornerRadius = 10
        TempButton.layer.cornerRadius = 10
        BatteryButton.layer.cornerRadius = 10
        TitleBar.isEditable = false
        
        // Do any additional setup after loading the view.
    }


}

