//
//  SomaControllable+Stub.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/5.
//  Copyright © 2018 SAP. All rights reserved.
//

import Foundation
import SocketIO

public final class SomaControllableToken: SomaControllable {

    public enum StubBehavior {
        /// Return a response immediately.
        case immediate

        /// Return a response after a delay.
        case delayed(seconds: TimeInterval)
    }

    public var state: SocketIOStatus = .notConnected

    public let target: SomaTargetType

    public let connectAction: () -> Void

    public let disconnectAction: () -> Void

    fileprivate let plugins: [SomaPluginType]

    public init(target: SomaTargetType, plugins: inout [SomaPluginType], connectAction: @escaping () -> Void = {}, disconnectAction: @escaping () -> Void = {}) {
        self.target = target
        self.connectAction = connectAction
        self.disconnectAction = disconnectAction
        self.plugins = plugins
    }

    public func connect() {
        state = .connected
        connectAction()
        plugins.forEach({ $0.didConnect(target: target) })

        if let emitInfo = target.emitInfo {
            emit(info: emitInfo)
        }
    }

    public func disconnect() {
        state = .disconnected
        disconnectAction()
        plugins.forEach({ $0.didDisconnect(target: target) })
    }

    public func destory() {
        state = .notConnected
        disconnectAction()
        plugins.forEach({ $0.didDisconnect(target: target) })
    }

    public func emit(info: SomaEmitType) {
        var aInfo = info
        plugins.forEach({ aInfo = $0.willEmit(target: target, emit: aInfo) })
    }

    @discardableResult
    public func sendStubData(behavior: StubBehavior, stubEvent: StubEventType) -> SomaControllableToken {
        let stub = createStubFunction(self, forStubEvent: stubEvent)
        switch behavior {
        case .immediate:
            stub()
        case .delayed(let delay):
            let killTimeOffset = Int64(CDouble(delay) * CDouble(NSEC_PER_SEC))
            let killTime = DispatchTime.now() + Double(killTimeOffset) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: killTime) {
                stub()
            }
        }
        return self
    }

    fileprivate func createStubFunction(_ token: SomaControllableToken, forStubEvent stubEvent: StubEventType) -> (() -> Void) {
        return { [weak self] () in
            guard token.state == .connected else {
                return
            }
            if let index = token.target.vaildateEvents?.index(where: { $0.name == stubEvent.name }) {
                if let item = stubEvent.item {
                    do {
                        var message = try SomaMessage(receiveItems: [item], from: token.target)
                        self?.plugins.forEach({ message = $0.process(target: token.target, message: message) })
                        token.target.vaildateEvents![index].didReceiveEvent(message: message)
                        self?.plugins.forEach({ $0.didReceive(target: token.target, message: message) })
                    }
                    catch let error as SomaError {
                        print(error.errorDescription())
                    }
                    catch {}
                }
                else {
                    do {
                        let message = try SomaMessage(receiveItems: nil, from: token.target)
                        token.target.vaildateEvents![index].didReceiveEvent(message: message)
                    }
                    catch let error as SomaError {
                        print(error.errorDescription())
                    }
                    catch {}
                }
            }
        }
    }
}

public protocol StubEventType {
    var name: String { get }

    var item: Dictionary<String, Any>? { get }
}
