//
//  SomaDisconnectable.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/4.
//  Copyright © 2018 SAP. All rights reserved.
//

import Foundation
import SocketIO

/// Protocol to define the opaque type returned from a request.
public protocol SomaControllable {

    /// A state value for connect status.
    var state: SocketIOStatus { get }

    /// Connect the represented socket.
    func connect()

    /// Disconnect the represented socket.
    func disconnect()

    /// Distory the socket connect and can't reconnect
    func destory()

    /// emit to the new room
    func emit(info: SomaEmitType)
}

extension SocketIOClient: SomaControllable {
    var plugins: [SomaPluginType]? {
        get {
            return value(forKeyString: "plugins") as? [SomaPluginType]
        }
        set {
            setValue(newValue, forKeyString: "plugins")
        }
    }

    var targetType: SomaTargetType? {
        get {
            return value(forKeyString: "targetType") as? SomaTargetType
        }
        set {
            setValue(newValue, forKeyString: "targetType")
        }
    }

    public func destory() {
        self.manager?.disconnectSocket(forNamespace: nsp)
    }

    public var state: SocketIOStatus {
        return status
    }

    public func emit(info: SomaEmitType) {
        var aInfo = info
        if let target = targetType {
            plugins?.forEach { aInfo = $0.willEmit(target: target , emit: aInfo)}
        }
        self.emit(aInfo.key, aInfo.value)
    }
}
