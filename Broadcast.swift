//
//  Broadcast.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 9/5/16.
//  Copyright © 2016 WildThink. All rights reserved.
//

/* Example usage

 protocol SomeClassOrProtocol.self) {
    func someClassOrProtocolFunction (some:Int, args:[String])
 }

 broadcast (SomeClassOrProtocol.self) {
    $0.someClassOrProtocolFunction(some, args)
 }

 broadcast { (target: SomeClassOrProtocol) in
    target.someClassOrProtocolFunction(some, args)
 }

 */

#if os(iOS)
    import UIKit

    public extension UIViewController {

        public func broadcast <T> (_ type: T.Type, from sender: Any = self, fn: (T) -> Void) -> Void
        {
            if willPerformBroadcast (type, sender: sender) {
                if let target = self as? T {
                    fn (target)
                }
            }
            for controller in childViewControllers {
                guard controller != self else { continue }
                controller.broadcast(type, from: sender, fn: fn)
            }
        }

        public func willPerformBroadcast <T> (_ type: T.Type, sender: Any) -> Bool {
            guard self != (sender as? UIViewController) else { return false }
            return self is T
        }
        
    }
#else
    import Cooca

    public extension NSViewController {

        public func broadcast <T> (type: T.Type, from sender: Any = self, fn: (T) -> Void) -> Void
        {
            if willPerformBroadcast (type: type, sender: sender) {
                if let target = self as? T {
                    fn (target)
                }
            }
            for controller in childViewControllers {
                guard controller != self else { continue }
                controller.broadcast(type: type, from: sender, fn: fn)
            }
        }

        public func willPerformBroadcast <T> (type: T.Type, sender: Any) -> Bool {
            guard self != (sender as? NSViewController) else { return false }
            return self is T
        }
        
    }

#endif

