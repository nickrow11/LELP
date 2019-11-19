//
//  uniBluetooth.swift
//  Application
//
//  Created by Admin on 11/17/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

import UIKit
import CoreBluetooth

class bluetoothData: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    public var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //update(newOut: "Central state update")
        print("Central state update")
        if central.state != .poweredOn{
            //update(newOut: "Central is not powered on")
            print("Central is not powered on")
        }
        else{
            //update(newOut: "Central scanning")
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID], options: [ CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    /*@IBOutlet weak var output: UITextView!
    func update(newOut: String){
        DispatchQueue.main.async {
            let Textfield = self.output.text+"\n"+newOut
            self.output.text = Textfield
        }
    }*/
    
    //have found device (did discover)
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI:NSNumber) {
        //Found the device, so stop the scan
        self.centralManager.stopScan()
        //update(newOut: "found device")
        print("found device")
        
        //copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        //Connect
        self.centralManager.connect(self.peripheral, options: nil)
        variables.vars.peripheral = self.peripheral
    }
    
    public func writeLEDValueToChar(_ peripheral: CBPeripheral, type: String ) {
        
        if type == "red" && variables.vars.redLED != nil {
            print(variables.vars.redLED!)
            peripheral.writeValue(Data([variables.vars.redLEDVal!]), for: variables.vars.redLED!, type: .withoutResponse)
        }
        if type == "green" && variables.vars.greenLED != nil {
            print(variables.vars.greenLED!)
            peripheral.writeValue(Data([variables.vars.greenLEDVal!]), for: variables.vars.greenLED!, type: .withoutResponse)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral{
            //update(newOut: "Connected to your device")
            print("Connected to your device")
            peripheral.discoverServices([ParticlePeripheral.buttonServiceUUID])
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID])
        }
    }    
    
    //check services (discover services)
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.buttonServiceUUID {
                    print("Button service found")
                    //discover characteristics
                    peripheral.discoverCharacteristics([ParticlePeripheral.button1ValUUID, ParticlePeripheral.button2ValUUID], for: service)
                }
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    print("LED service found")
                    //discover characteristics
                    peripheral.discoverCharacteristics([ParticlePeripheral.redLEDCharacteristicUUID, ParticlePeripheral.greenLEDCharacteristicUUID, ParticlePeripheral.blueLEDCharacteristicUUID], for: service)
                }
            }
            return
        }
    }
    
    //Checking and comparing all characteristics with the ones we are looking for (discover chars)
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.button1ValUUID{
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                    variables.vars.button1 = characteristic
                }
                if characteristic.uuid == ParticlePeripheral.button2ValUUID{
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                    variables.vars.button2 = characteristic
                }
                if characteristic.uuid == ParticlePeripheral.redLEDCharacteristicUUID{
                    print("Red LED found")
                    peripheral.setNotifyValue(false, for: characteristic)
                    variables.vars.redLED = characteristic
                    print("Red: ", variables.vars.redLED as Any)
                    variables.vars.redLEDVal = UInt8(0)
                    peripheral.writeValue(Data([variables.vars.redLEDVal!]), for: variables.vars.redLED!, type: .withoutResponse)
                }
                if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID{
                    print("Green LED found")
                    variables.vars.greenLED = characteristic
                    print("Green: ", variables.vars.greenLED as Any)
                    variables.vars.greenLEDVal = UInt8(0)
                    peripheral.writeValue(Data([variables.vars.greenLEDVal!]), for: variables.vars.greenLED!, type: .withoutResponse)
                }
                if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID{
                    print("Blue LED found")
                }
            }
        }
    }
    
    /*@IBAction func UpdateButton(_ sender: Any) {
        ReadButtonVal( withCharacteristic: Green!)
    }*/
    
    
    private func centralManager(_central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        if peripheral == self.peripheral
        {
            print("Disconnected")
            self.peripheral = nil
        }
        
        print("scanning for stuff")
        centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID], options:[CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    required override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}
