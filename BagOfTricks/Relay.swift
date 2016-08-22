//
//  Relay.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 5/11/15.
//  Copyright (c) 2015 Jason Jobe. All rights reserved.
//  https://gist.github.com/wildthink/19d43871964821c4f293
//
import Foundation

/* Examle usage

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


protocol Relay
{
    func relay <T> (type: T.Type, from: Any?, @noescape call: (T) -> Void) -> Void

    func nextRelay() -> Relay?
    func willPerformRelay <T> (type: T.Type, sender: Any) -> Bool
}

extension Relay {

    func relay <T> (type: T.Type, from: Any? = nil, @noescape call: (T) -> Void) -> Void
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

    func nextRelay() -> Relay? {
        return nil
    }
    func willPerformRelay <T> (type: T.Type, sender: Any) -> Bool {
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

extension Relay where Self: Application {
    func  nextRelay() -> Relay? {
        let next = nextResponder() ?? Application.sharedApplication()
        return next as? Relay
    }
}

extension Relay where Self: ApplicationDelegate {
    func  nextRelay() -> Relay? {
        return nil
    }
}

extension Relay where Self: Responder
{
    func  nextRelay() -> Relay? {
        let next = nextResponder() ?? Application.sharedApplication()
        return next as? Relay
    }
}

