//
//  Array+MapJson.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/5.
//  Copyright © 2018 SAP. All rights reserved.
//

import Foundation

extension Array {
    func mapJsonData() throws -> [Data] {
        print(self)
        return self.map({ (item) -> Data in
            do {
                if item is Data {
                    let jsonData = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                    return jsonData
                }
                else if item is NSData {
                    let jsonData = try JSONSerialization.data(withJSONObject: Data(referencing: item as! NSData), options: .prettyPrinted)
                    return jsonData
                }
                else if item is Dictionary<String, Any>, item is NSDictionary, item is Array<Any>, item is NSArray {
                    let jsonData = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                    return jsonData
                }
                else if item is String {
                    if let jsonData = (item as! String).data(using: String.Encoding.utf8) {
                        return jsonData
                    }
                    return Data()
                }
                else {
                    print("[ERROR] Can't map \(item) to Data")
                    throw NSError(domain: "[ERROR] Can't map \(item) to Data", code: 0, userInfo: nil)
                }
            }
            catch {
                return Data()
            }
        })
    }
}
