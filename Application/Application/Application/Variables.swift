//
//  Variables.swift
//  Application
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

import UIKit
import CoreBluetooth

//class that saves all the necessary variables that are needed to be shared across all classes
class variables {
    public var button1: CBCharacteristic?
    public var button2: CBCharacteristic?
    public var redLED: CBCharacteristic?
    public var greenLED: CBCharacteristic?
    public var redLEDVal: UInt8?
    public var greenLEDVal: UInt8?
    public var peripheral: CBPeripheral?
    public static let vars = variables()
}
