//
//  ParticlePeripheral.swift
//  Application
//
//  Created by Admin on 10/29/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreBluetooth

//class to save all predefined peripheral UUIDs
class ParticlePeripheral: NSObject {
    
    //new variables
    //should be only particle and datastream, others were used for tests
    
    public static let particleLEDServiceUUID = CBUUID.init(string: "72F76B32-8C92-E852-B2DB-380270270213")
     public static let redLEDCharacteristicUUID = CBUUID.init(string: "f0001111-0451-4000-b000-000000000000")
     public static let greenLEDCharacteristicUUID = CBUUID.init(string: "f0001112-0451-4000-b000-000000000000")
     public static let blueLEDCharacteristicUUID = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")
     
     public static let buttonServiceUUID = CBUUID.init(string: "f0001120-0451-4000-b000-000000000000")
     public static let button1ValUUID = CBUUID.init(string: "f0001121-0451-4000-b000-000000000000")
     public static let button2ValUUID = CBUUID.init(string: "f0001122-0451-4000-b000-000000000000")
     
     public static let dataStreamServiceUUID = CBUUID.init(string: "000000FF-0000-1000-8000-00805F9B34FB")
     public static let dataStreamUUID = CBUUID.init(string: "F0001131-0451-4000-B000-000000000000")
         public static let dataStreamCharacteristicUUID = CBUUID.init(string: "FF01")
}
