//
//  Relay.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 5/11/15.
//  Copyright (c) 2015 Jason Jobe. All rights reserved.
//  https://gist.github.com/wildthink/19d43871964821c4f293
//
import Foundation

/* Example usage

 protocol SomeClassOrProtocol.self) {
 func someClassOrProtocolFunction (some:Int, args:[String])
 }

 relay (SomeClassOrProtocol.self) {
 $0.someClassOrProtocolFunction(some, args)
 }

 relay { (target: SomeClassOrProtocol) in
 target.someClassOrProtocolFunction(some, args)
 }

 */


public protocol Relay
{
    func relay <T> (_ type: T.Type, from: Any?, call: (T) -> Void)

    func nextRelay() -> Relay?
    func willPerformRelay <T> (_ type: T.Type, sender: Any) -> Bool
}

public extension Relay {

    public func relay <T> (_ type: T.Type, from: Any? = nil, call: (T) -> Void)
    {
        if willPerformRelay(type, sender: from) {
            if let target = self as? T {
                call (target)
            }
        }
        else {
            nextRelay()?.relay(type, from: from ?? self, call: call)
        }
    }

    public func nextRelay() -> Relay? {
        return nil
    }
    public func willPerformRelay <T> (_ type: T.Type, sender: Any) -> Bool {
        return self is T
    }
}

#if os(iOS)
    import UIKit.UIResponder
    public typealias Responder = UIResponder
    public typealias Application = UIApplication
    public typealias ApplicationDelegate = UIApplicationDelegate
#else
    import AppKit.NSResponder
    public typealias Responder = NSResponder
    public typealias Application = NSApplication
    public typealias ApplicationDelegate = NSApplicationDelegate
#endif

public extension Relay where Self: Application {
    public func  nextRelay() -> Relay? {
        let nextRelay = next ?? Application.shared
        return nextRelay
    }
}

extension Relay where Self: ApplicationDelegate {
    public func nextRelay() -> Relay? {
        return nil
    }
}

public extension Relay where Self: Responder
{
    public func nextRelay() -> Relay? {
        let nextRelay = next ?? Application.shared
        return nextRelay
    }
}

extension UIResponder: Relay {}

