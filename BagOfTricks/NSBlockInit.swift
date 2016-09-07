//
//  NSBlockInit.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 3/19/16.
//  Copyright (c) 2016 Jason Jobe. All rights reserved.
//  https://gist.github.com/wildthink/48cce4cd2f27695ebb08
//
// Thanks to Mike Ash for his expertise and support of the community
// https://www.mikeash.com/pyblog/friday-qa-2015-12-25-swifty-targetaction.html
// Example usage
// let button = NSButton() {
//   $0.title = "Hello World"
// }
//

import Foundation

public protocol NSObjectBlockInitProtocol {}

public extension NSObjectBlockInitProtocol where Self: NSObject
{
    public init (setup: (Self) -> Void) {
        self.init()
        setup(self)
    }

    public func setup(setup: (Self) -> Void) -> Self {
        setup(self)
        return self
    }
}

extension NSObject: NSObjectBlockInitProtocol {}