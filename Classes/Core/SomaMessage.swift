//
//  SomaMessage.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/13.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit
import SocketIO

public enum SomaError: Swift.Error {
    case empty
    case jsonMapping(SomaMessage)
    case imageMapping(SomaMessage)

    func errorDescription() -> String {
        switch self {
        case .empty:
            return "The response data is empty"
        case .jsonMapping:
            return "Mapping to json data fail"
        case .imageMapping:
            return "Mapping to image fail"
        }
    }
}

public final class SomaMessage: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Receive message from namesapce: \(target.namespace), data: \(receiveItems)"
    }

    var receiveItems: [Any]

    var target: SomaTargetType

    public init(receiveItems: [Any]?, from target: SomaTargetType) throws {
        guard let receiveItems = receiveItems else {
            throw SomaError.empty
        }
        self.receiveItems = receiveItems
        self.target = target
    }
}

public extension SomaMessage {
    func mapJson() throws -> [Data] {
        do {
            return try receiveItems.mapJsonData()
        }
        catch {
            throw SomaError.jsonMapping(self)
        }
    }

    func mapImage() throws -> [UIImage] {
        let response = try receiveItems.map({ [unowned self] (data) -> UIImage in
            if data is Data {
                if let image = UIImage(data: data as! Data) {
                    return image
                }
                else {
                    throw SomaError.imageMapping(self)
                }
            }
            else {
                throw SomaError.imageMapping(self)
            }
        })
        return response
    }

    func map<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> [D] {
        do {
            let jsonDatas = try receiveItems.mapJsonData()
            return try jsonDatas.map { (data) -> D in
                return try decoder.decode(type, from: data)
            }
        }
        catch {
            throw SomaError.jsonMapping(self)
        }
    }
}
