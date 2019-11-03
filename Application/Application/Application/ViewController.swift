//
//  ViewController.swift
//  Application
//
//  Created by Admin on 9/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    //variables for Bluetooth
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    
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
                    Red = characteristic
                    print("Red: ", Red)
                    let test1:UInt8 = UInt8(0)
                    peripheral.writeValue(Data([test1]), for: characteristic, type: .withoutResponse)
                }
                if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID{
                    print("Green LED found")
                    Green = characteristic
                    print("Green: ", Green)
                    let test:UInt8 = UInt8(0)
                    peripheral.writeValue(Data([test]), for: characteristic, type: .withoutResponse)
                }
                if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID{
                    print("Blue LED found")
                }
            }
        }
    }
    
    private func writeLEDValueToChar( withCharacteristic characteristic: CBCharacteristic, withValue value: Data ) {
        
        if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {
            peripheral.writeValue(value, for: characteristic, type: .withoutResponse)
        }
    }

    //BUTTONS ON LIGHTS PAGE
    private var Red: CBCharacteristic?
    private var Green: CBCharacteristic?
    public var gVal:UInt8 = UInt8(0)
    public var rVal:UInt8 = UInt8(0)
    
    @IBAction func GButton(_ sender: Any) {
        if gVal == UInt8(0) {
            gVal = UInt8(1)
        } else {
            gVal = UInt8(0)
        }
            
        writeLEDValueToChar( withCharacteristic: Green!, withValue: Data([gVal]))
    }
    
    @IBAction func RButton(_ sender: Any) {
        if rVal == UInt8(0) {
            rVal = UInt8(1)
        } else {
            rVal = UInt8(0)
        }
            
        writeLEDValueToChar( withCharacteristic: Red!, withValue: Data([rVal]))
    }
    
    //END OF BLUETOOTH
    
    
    //BEGINNING OF UI FUNCTIONALITY
    //variables for buttons to link
    @IBOutlet weak var LightsButton: UIButton!
    @IBOutlet weak var PowerButton: UIButton!
    @IBOutlet weak var AudioButton: UIButton!
    @IBOutlet weak var VibrateButton: UIButton!
    @IBOutlet weak var TempButton: UIButton!
    @IBOutlet weak var BatteryButton: UIButton!
    @IBOutlet weak var TitleBar: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        //Bluetooth thing
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        PowerButton.layer.cornerRadius = 10
        LightsButton.layer.cornerRadius = 10
        AudioButton.layer.cornerRadius = 10
        VibrateButton.layer.cornerRadius = 10
        TempButton.layer.cornerRadius = 10
        BatteryButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }


}

