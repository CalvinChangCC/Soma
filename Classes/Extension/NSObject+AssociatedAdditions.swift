//
//  NSObject+AssociatedAdditions.swift
//  Soma
//
//  Created by Calvin Chang on 31/03/2018.
//  Copyright © 2018 SapphireInfo. All rights reserved.
//

import Foundation
import ObjectiveC

public struct AssociationKey<Value> {
    fileprivate let address: UnsafeRawPointer
    fileprivate let `default`: Value!

    /// Create an ObjC association key.
    ///
    /// - warning: The key must be uniqued.
    ///
    /// - parameters:
    ///   - default: The default value, or `nil` to trap on undefined value. It is
    ///              ignored if `Value` is an optional.
    init(default: Value? = nil) {
        self.address = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
        self.default = `default`
    }

    /// Create an ObjC association key from a `StaticString`.
    ///
    /// - precondition: `key` has a pointer representation.
    ///
    /// - parameters:
    ///   - default: The default value, or `nil` to trap on undefined value. It is
    ///              ignored if `Value` is an optional.
    init(key: StaticString, default: Value? = nil) {
        assert(key.hasPointerRepresentation)
        self.address = UnsafeRawPointer(key.utf8Start)
        self.default = `default`
    }
}

internal extension NSObject {
    /// Retrieve the associated value for the specified key.
    ///
    /// - parameters:
    ///   - key: The key.
    ///
    /// - returns: The associated value, or the default value if no value has been
    ///            associated with the key.
    func value<Value>(forAssociationKey key: AssociationKey<Value>) -> Value {
        return (objc_getAssociatedObject(self, key.address) as! Value?) ?? key.default
    }

    /// Retrieve the associated value for the specified key.
    ///
    /// - parameters:
    ///   - key: The key.
    ///
    /// - returns: The associated value, or `nil` if no value is associated with
    ///            the key.
    func value<Value>(forAssociationKey key: AssociationKey<Value?>) -> Value? {
        return objc_getAssociatedObject(self, key.address) as! Value?
    }

    /// Retrieve the associated value for the specified key string.
    ///
    /// - parameters:
    ///   - key: The key string.
    ///
    /// - returns: The associated value, or the default value if no value has been
    ///            associated with the key.
    func value(forKeyString key: StaticString) -> Any? {
        return objc_getAssociatedObject(self, UnsafeRawPointer(key.utf8Start))
    }

    /// Retrieve the associated value for the specified key.
    ///
    /// - parameters:
    ///   - key: The key.
    ///
    /// - returns: The associated value, or `nil` if no value is associated with
    ///            the key.
    func value(forKeyString key: StaticString, defaultValue: () -> Any?) -> Any? {
        return objc_getAssociatedObject(self, UnsafeRawPointer(key.utf8Start)) ?? defaultValue()!
    }

    /// Set the associated value for the specified key.
    ///
    /// - parameters:
    ///   - value: The value to be associated.
    ///   - key: The key.
    func setValue<Value>(_ value: Value, forAssociationKey key: AssociationKey<Value>) {
        willChangeValue(forKey: "self")
        objc_setAssociatedObject(self, key.address, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: "self")
    }

    /// Set the associated value for the specified key.
    ///
    /// - parameters:
    ///   - value: The value to be associated.
    ///   - key: The key.
    func setValue<Value>(_ value: Value?, forAssociationKey key: AssociationKey<Value?>) {
        willChangeValue(forKey: "self")
        objc_setAssociatedObject(self, key.address, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: "self")
    }

    /// Set the associated value for the specified key string.
    ///
    /// - parameters:
    ///   - value: The value to be associated.
    ///   - key: The key string.
    func setValue<Value>(_ value: Value, forKeyString key: StaticString) {
        willChangeValue(forKey: "self")
        objc_setAssociatedObject(self, UnsafeRawPointer(key.utf8Start), value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: "self")
    }

    /// Set the associated value for the specified key string.
    ///
    /// - parameters:
    ///   - value: The value to be associated.
    ///   - key: The key string.
    func setValue<Value>(_ value: Value?, forKeyString key: StaticString) {
        willChangeValue(forKey: "self")
        objc_setAssociatedObject(self, UnsafeRawPointer(key.utf8Start), value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: "self")
    }
}
