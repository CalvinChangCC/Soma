//
//  SomaEmitType.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/4.
//  Copyright © 2018 SAP. All rights reserved.
//

import Foundation
import SocketIO

public protocol SomaEmitType {
    typealias SomaEmitData = SocketData
    
    /// The target's base `room`.
    var key: String { get }

    var value: SomaEmitData { get }
}
