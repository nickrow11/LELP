//
//  Bluetooth.swift
//  ApplicationTests
//
//  Created by Admin on 11/3/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import XCTest
import UIKit
import CoreBluetooth


class Bluetooth: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {

    //variables for Bluetooth
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
            centralManager = CBCentralManager(delegate: self, queue: nil)
    
    //BEGINNING OF BLUETOOTH FUNCTIONS
    //scan for devices (status update)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        update(newOut: "Central state update")
        print("Central state update")
        if central.state != .poweredOn{
            update(newOut: "Central is not powered on")
            print("Central is not powered on")
        }
        else{
            update(newOut: "Central scanning")
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID], options: [ CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    @IBOutlet weak var output: UITextView!
    func update(newOut: String){
        DispatchQueue.main.async {
            let Textfield = self.output.text+"\n"+newOut
            self.output.text = Textfield
        }
    }
    
    //have found device (did discover)
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI:NSNumber) {
        //Foudn the device, so stop the scan
        self.centralManager.stopScan()
        update(newOut: "found device")
        print("found device")
        
        //copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        //Connect
        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    
    //double check if correct device (did connect)
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral{
            update(newOut: "Connected to your device")
            print("Connected to your device")
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID])
        }
    }
    
    
    //check services (discover services)
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    update(newOut: "Service found")
                    print("LED service found")
                    //discover characteristics
                    peripheral.discoverCharacteristics([ParticlePeripheral.redLEDCharacteristicUUID, ParticlePeripheral.greenLEDCharacteristicUUID, ParticlePeripheral.blueLEDCharacteristicUUID], for: service)
                    
                    return
                }
            }
        }
    }
    
    //Checking and comparing all characteristics with the ones we are looking for (discover chars)
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.redLEDCharacteristicUUID{
                    print("Red LED found")
                }
                if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID{
                    print("Green LED found")
                }
                if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID{
                    print("Blue LED found")
                }
            }
        }
    }

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }



    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
