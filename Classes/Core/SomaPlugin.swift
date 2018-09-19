//
//  SomaPlugin.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/12.
//  Copyright © 2018 SAP. All rights reserved.
//

import Foundation

public protocol SomaPluginType {
    func didConnect(target: SomaTargetType)

    func didDisconnect(target: SomaTargetType)

    func willEmit(target: SomaTargetType, emit: SomaEmitType) -> SomaEmitType

    func didReceive(target: SomaTargetType, message: SomaMessage)

    func process(target: SomaTargetType, message: SomaMessage) -> SomaMessage

    func didTimeout(target: SomaTargetType)

    func didErrorOccur(target: SomaTargetType, errors: [Any])
}

public extension SomaPluginType {
    func didConnect(target: SomaTargetType) {}

    func didDisconnect(target: SomaTargetType) {}

    func willEmit(target: SomaTargetType, emit: SomaEmitType) -> SomaEmitType { return emit }

    func didReceive(target: SomaTargetType, message: SomaMessage) {}

    func process(target: SomaTargetType, message: SomaMessage) -> SomaMessage { return message }

    func didTimeout(target: SomaTargetType) {}

    func didErrorOccur(target: SomaTargetType, errors: [Any]) {}
}
