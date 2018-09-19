//
//  SomaTargetType.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/4.
//  Copyright © 2018 SAP. All rights reserved.
//

import Foundation
import SocketIO

public protocol SomaTargetType {
    
    /// The target's base `name space`.
    var namespace: String { get }

    /// Socket timeout interval
    var timeoutInterval: TimeInterval { get }

    /// Socket default room
    var emitInfo: SomaEmitType? { get }

    /// The accept event name which want to receive
    var vaildateEvents: [SomaEventType]? { get }
}
