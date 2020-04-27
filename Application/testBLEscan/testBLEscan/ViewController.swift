//
//  ViewController.swift
//  testBLEscan
//
//  Created by Admin on 4/21/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {
    private var centralManager : CBCentralManager!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print ("Bluetooth is On")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        else{
            print ("Bluetooth is not active")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertismentData: [String : Any], rssi RSSI: NSNumber) {
        print("\nName   : \(peripheral.name ?? "(No name)")")
        print("RSSI : \(RSSI)")
        for ad in advertismentData{
            print("AD Data: \(ad)")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }


}

