//
//  SomaProvider.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/4.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit
import SocketIO

public protocol SomaProviderType: AnyObject {

    associatedtype Target: SomaTargetType

    /// Designated connect-making method. Returns a `SomaControllable` token to controll the socket connect later.
    func connect(_ target: Target) -> SomaControllable
}

open class SomaProvider<Target: SomaTargetType>: SomaProviderType {

     /// The path to be appended to `serverURL` to form the full `URL`.
    open var serverURL: URL

    /// The token for connect to socket.io server
    open var connectParams: [String: Any]?

    public let manager: SocketManager

    open var plugins: [SomaPluginType]

    open var forceNew = false {
        didSet {
            manager.forceNew = forceNew
        }
    }

    public init(serverURL: URL, connectParams: [String: Any]? = nil, plugins: [SomaPluginType] = []) {
        self.serverURL = serverURL
        self.connectParams = connectParams
        self.manager = SocketManager(socketURL: serverURL, config: [.connectParams(connectParams ?? [:]), .log(false), .forceNew(false)])
        self.plugins = plugins
    }

    @discardableResult
    public func connect(_ target: Target) -> SomaControllable {

        if let client = manager.nsps[target.namespace] {
            client.disconnect()
        }
        else {
            let newClient = SocketIOClient(manager: manager, nsp: target.namespace)
            manager.nsps[target.namespace] = newClient
        }

        guard let client = manager.nsps[target.namespace] else {
            fatalError("[SOMA][ERROR] SocketIOClient is null")
        }

        client.on(clientEvent: .connect) { [weak self] (receive, emitter) in
            if var emitInfo = target.emitInfo {
                self?.plugins.forEach({ emitInfo = $0.willEmit(target: target, emit: emitInfo) })
                client.emit(emitInfo.key, emitInfo.value)
            }
            self?.plugins.forEach({ $0.didConnect(target: target) })
        }

        client.on(clientEvent: .disconnect) { [weak self] _, _  in
            self?.plugins.forEach({ $0.didDisconnect(target: target) })
        }

        client.on(clientEvent: .error) { [weak self] (errors, _)  in
            self?.plugins.forEach({ $0.didErrorOccur(target: target, errors: errors) })
            print(errors)
        }

        if let events = target.vaildateEvents {
            for event in events {
                client.on(event.name) { [weak self] (items, emitter) in
                    do {
                        var message = try SomaMessage(receiveItems: items, from: target)
                        self?.plugins.forEach({ message = $0.process(target: target, message: message) })
                        event.didReceiveEvent(message: message)
                        self?.plugins.forEach({ $0.didReceive(target: target, message: message) })
                    }
                    catch let error as SomaError {
                        print(error.errorDescription())
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }

        client.connect(timeoutAfter: target.timeoutInterval) { [weak self] () in
            self?.plugins.forEach({ $0.didTimeout(target: target) })
        }

        // For plugin
        client.plugins = plugins
        client.targetType = target

        return client
    }

    @discardableResult
    open func stubConnect(_ target: Target) -> SomaControllableToken {
        let controllableToken = SomaControllableToken(target: target, plugins: &plugins)

        return controllableToken
    }
}
