//
//  ParticlePeripheral.swift
//  Application
//
//  Created by Admin on 10/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreBluetooth

class ParticlePeripheral: NSObject {
    
    //leds
    //our thing's ID = AD567F04-6F17-407A-C09E-396D50CD9918
    //our thing's service UUID's = f0001110-0451-4000-b000-000000000000
    //public static let particleLEDServiceUUID = CBUUID.init(string: "b4250400-fb4b-4746-b2b0-93f0e61122c6")
    public static let particleLEDServiceUUID = CBUUID.init(string: "f0001110-0451-4000-b000-000000000000")
    public static let redLEDCharacteristicUUID = CBUUID.init(string: "f0001111-0451-4000-b000-000000000000")
    public static let greenLEDCharacteristicUUID = CBUUID.init(string: "f0001112-0451-4000-b000-000000000000")
    public static let blueLEDCharacteristicUUID = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")
    
    public static let buttonServiceUUID = CBUUID.init(string: "f0001120-0451-4000-b000-000000000000")
    public static let button1ValUUID = CBUUID.init(string: "f0001121-0451-4000-b000-000000000000")
    public static let button2ValUUID = CBUUID.init(string: "f0001122-0451-4000-b000-000000000000")
    
 /*   public static let redLEDCharacteristicUUID = CBUUID.init(string: "b4250401-fb4b-4746-b2b0-93f0e61122c6")
    public static let greenLEDCharacteristicUUID = CBUUID.init(string: "b4250402-fb4b-4746-b2b0-93f0e61122c6")
    public static let blueLEDCharacteristicUUID = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")*/
}
