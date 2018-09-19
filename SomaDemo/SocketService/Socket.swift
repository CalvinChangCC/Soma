//
//  Socket.swift
//  SomaDemo
//
//  Created by Calvin Chang on 2018/9/19.
//  Copyright © 2018 CalvinChang. All rights reserved.
//

import UIKit
import Soma

let demoSoket = SomaProvider<SocketType>(serverURL: URL(string: "http://test.domain.com") ?? URL(fileURLWithPath: ""),
                                                     plugins: [SomaLoggerPlugin(verbose: true)])

enum SocketType: SomaTargetType {
    case message(SomaEmitType, SomaEventType)
    case stateUpdate(SomaEventType)
    case infoUpdate([SomaEventType])

    var namespace: String {
        switch self {
        case .message:
            return "/message"
        case .stateUpdate:
            return "/stateUpdate"
        case .infoUpdate:
            return "/infoUpdate"
        }
    }

    var timeoutInterval: TimeInterval {
        return 5
    }

    var emitInfo: SomaEmitType? {
        switch self {
        case .message(let info, _):
            return info
        default:
            return nil
        }
    }

    var vaildateEvents: [SomaEventType]? {
        switch self {
        case .message(_, let event):
            return [event]
        case .stateUpdate(let event):
            return [event]
        case .infoUpdate(let events):
            return events
        }
    }
}
