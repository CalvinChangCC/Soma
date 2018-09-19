//
//  SomaLoggerPlugin.swift
//  SportsBook
//
//  Created by Calvin Chang on 2018/9/14.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit

public final class SomaLoggerPlugin: SomaPluginType {
    fileprivate let loggerId = "Soma_Logger"
    fileprivate let dateFormatString = "dd/MM/yyyy HH:mm:ss"
    fileprivate let dateFormatter = DateFormatter()

    /// A Boolean value determing whether response body data should be logged.
    public let isVerbose: Bool

    public init(verbose: Bool = false) {
        self.isVerbose = verbose
    }

    public func didConnect(target: SomaTargetType) {
        output(format(identifier: target.namespace, message: "Socket connect"))
    }

    public func didDisconnect(target: SomaTargetType) {
        output(format(identifier: target.namespace, message: "Socket disconnect"))
    }

    public func willEmit(target: SomaTargetType, emit: SomaEmitType) -> SomaEmitType {
        output(format(identifier: target.namespace, message: "Emit (\(emit.key)) with data length (\(emit.value))"))
        return emit
    }

    public func didReceive(target: SomaTargetType, message: SomaMessage) {
        output(format(identifier: target.namespace, message: message.debugDescription))
    }

    public func didTimeout(target: SomaTargetType) {
        output(format(identifier: target.namespace, message: "Socket connect timeout"))
    }

    public func didErrorOccur(target: SomaTargetType, errors: [Any]) {
        output(format(identifier: target.namespace, message: "Socket error occur \nError: [\(errors)]"))
    }

    fileprivate func output(_ text: String) {
        if isVerbose {
            print(text)
        }
    }
}

private extension SomaLoggerPlugin {
    var date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }

    func format(identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] Name Space - \(identifier): \(message)"
    }
}
