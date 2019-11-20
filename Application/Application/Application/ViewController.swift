//
//  ViewController.swift
//  Application
//
//  Created by Admin on 9/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreBluetooth

//class for main menu, controls all present buttons on the main menu
class ViewController: UIViewController {
    
    //BEGINNING OF UI FUNCTIONALITY
    //variables for buttons to link
    @IBOutlet weak var TitleBar: UITextView!
    @IBOutlet weak var readButtons: UIButton!
    @IBOutlet weak var lightsButton: UIButton!
    @IBOutlet weak var vibrateButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    
    //temp function for reading physical button values
    @IBAction func readButtons(_ sender: Any) {
        print("Button 1: ", variables.vars.button1!)
        print("Button 2: ", variables.vars.button2!)
    }
    
    //override function that adds settings to present buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightsButton.layer.cornerRadius = 5
        vibrateButton.layer.cornerRadius = 5
        audioButton.layer.cornerRadius = 5
    }


}

//class that controls all UI functions on lights subclass
class lightsViewController: UIViewController {
    @IBOutlet weak var onLED: UIButton!
    @IBOutlet weak var offLED: UIButton!
    
    //function that toggles all the LEDs on and off, controlled by "LEDs On" button
    @IBAction func toggleLED(_ sender: Any) {
        if variables.vars.greenLEDVal == UInt8(0) {
            variables.vars.greenLEDVal = UInt8(1)
        } else {
            variables.vars.greenLEDVal = UInt8(0)
        }
            
        bluetoothData().writeLEDValueToChar(variables.vars.peripheral!, type: "led")
    }
    
    //override function that adds settings to present buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLED.layer.cornerRadius = 5
        offLED.layer.cornerRadius = 5
    }
}

//class that controls all UI functions on lights subclass
class audioViewController: UIViewController {
    @IBOutlet weak var onAudio: UIButton!
    @IBOutlet weak var offAudio: UIButton!
    
    //override function that adds settings to present buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onAudio.layer.cornerRadius = 5
        offAudio.layer.cornerRadius = 5
    }
}

//class that controls all UI functions on lights subclass
class vibrateViewController: UIViewController {
    @IBOutlet weak var onVibrate: UIButton!
    @IBOutlet weak var offVibrate: UIButton!
    
    //function that toggles the vibration on and off, controlled by the "Vibrate On" button
    @IBAction func toggleVibrate(_ sender: Any) {
        if variables.vars.redLEDVal == UInt8(0) {
            variables.vars.redLEDVal = UInt8(1)
        } else {
            variables.vars.redLEDVal = UInt8(0)
        }
            
        bluetoothData().writeLEDValueToChar(variables.vars.peripheral!, type: "vibrate")
    }
    
    //override function that adds settings to present buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onVibrate.layer.cornerRadius = 5
        offVibrate.layer.cornerRadius = 5
    }
}
