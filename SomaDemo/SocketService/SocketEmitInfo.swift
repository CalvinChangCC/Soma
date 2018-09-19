//
//  SocketEmitInfo.swift
//  SomaDemo
//
//  Created by Calvin Chang on 2018/9/19.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit
import Soma

class SocketEmitInfo: SomaEmitType {
    var key = "join"

    var value: SomaEmitData {
        return ["Emit information"]
    }
}
