//
//  ActionTrampoline.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 3/17/16.
//  Copyright © 2016 WildThink. All rights reserved.
//
//  https://gist.githubusercontent.com/wildthink/677308084ab364044c76/raw/f713efca9ec6ca9b56c4405bd82ae33b1db98ec7/ActionTrampoline.swift
//
// Kudos (again) to Mike Ash!
// https://www.mikeash.com/pyblog/friday-qa-2015-12-25-swifty-targetaction.html
//

import Foundation


#if os(iOS)
    import UIKit

    public protocol UIControlActionFunctionProtocol {}

    open class ActionTrampoline<T>: NSObject
    {
        var action: (T) -> Void

        init(action: @escaping (T) -> Void) {
            self.action = action
        }

        @objc func performAction(_ sender: UIControl) {
            action(sender as! T)
        }
    }

let NSControlActionFunctionProtocolAssociatedObjectKey = UnsafeMutablePointer<Int8>.allocate(capacity: 1)

    extension UIControlActionFunctionProtocol where Self: UIControl
    {
        func addAction(_ events: UIControlEvents, _ action: @escaping (Self) -> Void) {
            let trampoline = ActionTrampoline(action: action)
            let call = #selector(trampoline.performAction(_:))
            self.addTarget(trampoline, action: call, for: events)
            objc_setAssociatedObject(self, NSControlActionFunctionProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
        }

        func setup(_ setup: (Self) -> Void) -> Self {
            setup(self)
            return self
        }
    }

    extension UIControl: UIControlActionFunctionProtocol {}

#else

    import Cocoa

    public protocol NSControlActionFunctionProtocol {}

    public class ActionTrampoline<T>: NSObject
    {
        var action: T -> Void

        init(action: T -> Void) {
            self.action = action
        }

        @objc func performAction(sender: NSControl) {
            action(sender as! T)
        }
    }

let NSControlActionFunctionProtocolAssociatedObjectKey = UnsafeMutablePointer<Int8>.allocate(capacity: 1)

    extension NSControlActionFunctionProtocol where Self: NSControl
    {
        func addAction(action: Self -> Void) {
            let trampoline = ActionTrampoline(action: action)
            self.target = trampoline
            self.action = #selector(trampoline.performAction(_:))
            objc_setAssociatedObject(self, NSControlActionFunctionProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
        }

        func setup(setup: (Self) -> Void) -> Self {
            setup(self)
            return self
        }
    }
    
    extension NSControl: NSControlActionFunctionProtocol {}
    
#endif
