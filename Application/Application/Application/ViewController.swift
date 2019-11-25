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
    @IBOutlet weak var tempValue: UILabel!
    
    //temp function for reading physical button values
    @IBAction func readButtons(_ sender: Any) {
        bluetoothData().readTempVal(variables.vars.peripheral!)
        tempValue.text = "\(variables.vars.Temp![2])°"
    }
    
    //override function that adds settings to present buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightsButton.layer.cornerRadius = 5
        vibrateButton.layer.cornerRadius = 5
        audioButton.layer.cornerRadius = 5
        readButtons.layer.cornerRadius = 5
    }


}

//class that controls all UI functions on lights subclass
class lightsViewController: UIViewController {
    
    @IBAction func redLEDControl(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        if currentValue == 0 {
            bluetoothData().changeLEDColor(variables.vars.peripheral!, value: currentValue, color: "red")
        } else if currentValue == 255 {
            bluetoothData().changeLEDColor(variables.vars.peripheral!, value: currentValue, color: "red")
        }
    }
    
    @IBAction func greenLEDControl(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        if currentValue == 0 {
            bluetoothData().changeLEDColor(variables.vars.peripheral!, value: currentValue, color: "green")
        } else if currentValue == 255 {
            bluetoothData().changeLEDColor(variables.vars.peripheral!, value: currentValue, color: "green")
        }
    }
    
    @IBAction func blueLEDControl(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        if currentValue == 0 {
            bluetoothData().changeLEDColor(variables.vars.peripheral!, value: currentValue, color: "blue")
        } else if currentValue == 255 {
            bluetoothData().changeLEDColor(variables.vars.peripheral!, value: currentValue, color: "blue")
        }
    }
    
    //override function that adds settings to present buttons
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func vibrateControl(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        if currentValue == 0 {
            bluetoothData().toggleVibrate(variables.vars.peripheral!, value: currentValue)
        } else if currentValue == 100 {
            bluetoothData().toggleVibrate(variables.vars.peripheral!, value: currentValue)
        }
    }
    
    //override function that adds settings to present buttons
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
