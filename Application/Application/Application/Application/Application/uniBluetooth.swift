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
            if central.state == .poweredOn {
                print ("Bluetooth is On")
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
            else{
                print ("Bluetooth is not active")
            }
        }
    }
    
    //finds the device that is being serched for and saves peripheral information to use in other classes
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI:NSNumber) {
        
        if(peripheral.name == "LullabyPacifier_BLE")
        {
        print("\nName   : \(peripheral.name ?? "(No name)")")
        print("RSSI : \(RSSI)")
        for ad in advertisementData{
            print("AD Data: \(ad)")
            }
        }
            
        //Found the device, so stop the scan
        if(peripheral.name == "LullabyPacifier_BLE")
        {
            self.centralManager.stopScan()
            print("found device")
        }
        
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
    }
    
    public func changeLEDColor(_ peripheral: CBPeripheral, value: Int, color: String ) {
        if value == 0 {
            if color == "red" {
                variables.vars.dataStreamLEDArray![2] = 0x00
                peripheral.writeValue(Data(_: variables.vars.dataStreamLEDArray!), for: variables.vars.dataStream!, type: .withResponse)
            } else if color == "green" {
                variables.vars.dataStreamLEDArray![3] = 0x00
                peripheral.writeValue(Data(_: variables.vars.dataStreamLEDArray!), for: variables.vars.dataStream!, type: .withResponse)
            } else {
                variables.vars.dataStreamLEDArray![4] = 0x00
                peripheral.writeValue(Data(_: variables.vars.dataStreamLEDArray!), for: variables.vars.dataStream!, type: .withResponse)
            }
        } else {
            if color == "red" {
                variables.vars.dataStreamLEDArray![2] = 0x01
                peripheral.writeValue(Data(_: variables.vars.dataStreamLEDArray!), for: variables.vars.dataStream!, type: .withResponse)
            } else if color == "green" {
                variables.vars.dataStreamLEDArray![3] = 0x01
                peripheral.writeValue(Data(_: variables.vars.dataStreamLEDArray!), for: variables.vars.dataStream!, type: .withResponse)
            } else {
                variables.vars.dataStreamLEDArray![4] = 0x01
                peripheral.writeValue(Data(_: variables.vars.dataStreamLEDArray!), for: variables.vars.dataStream!, type: .withResponse)
            }
        }
    }
    
    public func toggleVibrate(_ peripheral: CBPeripheral, value: Int ) {
        if value == 0 {
            variables.vars.dataStreamVibrateArray?[0] = 0x03
            variables.vars.dataStreamVibrateArray?[1] = 0xD0
            variables.vars.dataStreamVibrateArray?[2] = 0x01
            //variables.vars.dataStreamVibrateArray![2] = 0x00
            peripheral.writeValue(Data(_: variables.vars.dataStreamVibrateArray!), for: variables.vars.dataStream!, type: .withResponse)
        } else {
            variables.vars.dataStreamVibrateArray![2] = 0x01
            peripheral.writeValue(Data(_: variables.vars.dataStreamVibrateArray!), for: variables.vars.dataStream!, type: .withResponse)
        }
    }
    
    public func readTempVal(_ peripheral: CBPeripheral) {
        let data:[UInt8] = [0x03, 0xE0]
        peripheral.writeValue(Data(_: data), for: variables.vars.dataStream!, type: .withResponse)
        let val = variables.vars.dataStream!.value ?? NSData() as Data
        variables.vars.Temp = val as NSData
    }
    
    //function that finds all available peripherals in a bluetooth device when connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral{
            print("Connected to your device")
            peripheral.discoverServices([ParticlePeripheral.buttonServiceUUID])
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID])
            peripheral.discoverServices([ParticlePeripheral.dataStreamServiceUUID])
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
                if service.uuid == ParticlePeripheral.dataStreamServiceUUID {
                    print("Data Stream found")
                    //discover characteristic
                    peripheral.discoverCharacteristics(
                        [ParticlePeripheral.dataStreamUUID], for: service)
                    print("\nDataStream uuid: ",service.uuid)
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
                if characteristic.uuid ==
                    ParticlePeripheral.dataStreamCharacteristicUUID{
                    print("test: ", characteristic.uuid)
                    variables.vars.dataStream = characteristic
                    variables.vars.dataStreamLEDArray = [0x05, 0xC0, 0x00, 0x00, 0x00]
                    variables.vars.dataStreamVibrateArray = [0x03, 0xD0, 0x00]
                    
                    //earlier test for data output
                    /*
                    let data:[UInt8] = [0x03, 0xE0]
                    peripheral.writeValue(Data(_: data), for: variables.vars.dataStream!, type: .withResponse)
                    let val = characteristic.value ?? NSData() as Data
                    print(val as NSData)
                    var temp = val as NSData
                    print(temp[2])
                    */
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
