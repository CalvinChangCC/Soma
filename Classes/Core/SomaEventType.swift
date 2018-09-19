//
//  SomaEventType.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/4.
//  Copyright © 2018 SAP. All rights reserved.
//

import Foundation

public protocol SomaEventType {
    var name: String { get }

    func didReceiveEvent(message: SomaMessage)
}
