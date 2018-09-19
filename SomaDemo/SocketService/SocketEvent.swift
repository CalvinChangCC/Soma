//
//  SocketEvent.swift
//  SomaDemo
//
//  Created by Calvin Chang on 2018/9/19.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit
import Soma

class SocketEvent: SomaEventType {
    var name = "update"

    func didReceiveEvent(message: SomaMessage) {
        print("[DEBUG] Receive message \(try! message.mapJson())")
    }
}
