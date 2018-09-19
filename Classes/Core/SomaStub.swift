//
//  SomaStub.swift
//  Soma
//
//  Created by Calvin Chang on 2018/9/5.
//  Copyright © 2018 SAP. All rights reserved.
//

import UIKit

class SomaStub: NSObject {
    class func createJsonString(by fileName: String, ofType: String) -> String {
        do {
            if let path = Bundle.main.path(forResource: fileName, ofType: ofType) {
                return try String(contentsOfFile: path)
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
}
