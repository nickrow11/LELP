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

//class for all bluetooth functionality
class bluetoothData: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    public var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    //starts the bluetooth connectivity process
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn{
            print("Central is not powered on")
        }
        else{
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID], options: [ CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    //finds the device that is being serched for and saves peripheral information to use in other classes
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI:NSNumber) {
        //Found the device, so stop the scan
        self.centralManager.stopScan()
        print("found device")
        
        //copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        //Connect
        self.centralManager.connect(self.peripheral, options: nil)
        variables.vars.peripheral = self.peripheral
    }
    
    //function that writes a UInt8 type variable to the board's LEDs
    public func writeLEDValueToChar(_ peripheral: CBPeripheral, type: String ) {
        
        if type == "vibrate" && variables.vars.redLED != nil {
            print(variables.vars.redLED!)
            peripheral.writeValue(Data([variables.vars.redLEDVal!]), for: variables.vars.redLED!, type: .withoutResponse)
        }
        if type == "led" && variables.vars.greenLED != nil {
            print(variables.vars.greenLED!)
            peripheral.writeValue(Data([variables.vars.greenLEDVal!]), for: variables.vars.greenLED!, type: .withoutResponse)
        }
    }
    
    //function that finds all available peripherals in a bluetooth device when connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral{
            print("Connected to your device")
            peripheral.discoverServices([ParticlePeripheral.buttonServiceUUID])
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID])
        }
    }    
    
    //check if services that are predefined exist
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
    
    //attemps at connecting to all predefined peripherals that were found, then saves all necesarry information to allow other classes to manipulate the peripherals
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
                    peripheral.setNotifyValue(false, for: characteristic)
                    variables.vars.redLED = characteristic
                    variables.vars.redLEDVal = UInt8(0)
                    peripheral.writeValue(Data([variables.vars.redLEDVal!]), for: variables.vars.redLED!, type: .withoutResponse)
                }
                if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID{
                    variables.vars.greenLED = characteristic
                    variables.vars.greenLEDVal = UInt8(0)
                    peripheral.writeValue(Data([variables.vars.greenLEDVal!]), for: variables.vars.greenLED!, type: .withoutResponse)
                }
                if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID{
                    print("Blue LED found")
                }
            }
        }
    }
    
    //function that rescans for bluetooth functionality when peripherals or device disconnects
    private func centralManager(_central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        if peripheral == self.peripheral
        {
            print("Disconnected")
            self.peripheral = nil
        }
        
        print("scanning for stuff")
        centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID], options:[CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    //function that runs when the class is instantiated in AppDelegate (forces the required bluetooth functions to run and connect to device)
    required override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}
