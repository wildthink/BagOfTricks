//
//  Publisher.swift
//  Pods
//
//  Created by Jason Jobe on 9/24/16.
//  Copyright © 2016 WildThink. All rights reserved.
//

import Foundation

public class Publisher: NSObject
{
    fileprivate var actions = Set<PubAction<AnyObject>>()

    // MARK: - Subscription

    func add (_ action: PubAction<AnyObject>?) {
        guard let action = action else { return }
        actions.insert (action)
    }

    func remove (_ action: PubAction<AnyObject>?) {
        guard let action = action else { return }
        actions.remove(action)
    }

    func publish () {
        for action in actions {
            action.publish(from: self)
        }
    }
}

public protocol PublishActionFunctionProtocol {}

public class PubAction<T: AnyObject>: NSObject
{
    var action: (Publisher, T) -> Void
    weak var target: T?

    init(action: @escaping (Publisher, T) -> Void) {
        self.action = action
    }

    // If the target is nil then it has been released and 
    // this action is not longer relevant
    @objc func publish(from publisher: Publisher) {
        guard let target = target else {
            publisher.remove (self as? PubAction<AnyObject>)
            return
        }
        action(publisher, target as! T)
    }
}

let PublishActionFunctionProtocolAssociatedObjectKey = UnsafeMutablePointer<Int8>.allocate(capacity: 1)

extension PublishActionFunctionProtocol where Self: NSObject
{
    func subscribe (to publisher: Publisher?, action: @escaping (Publisher, Self) -> Void) {
        guard let publisher = publisher else { return }
        let action = PubAction(action: action)
        action.target = self
        publisher.add (self as? PubAction<AnyObject>)
    }

    func setup(setup: (Self) -> Void) -> Self {
        setup(self)
        return self
    }
}

extension NSObject: PublishActionFunctionProtocol {}

