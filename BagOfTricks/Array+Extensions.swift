//
//  Array+Extensions.swift
//  Pods
//
//  Created by Jason Jobe on 10/5/16.
//  Copyright © 2016 WildThink. All rights reserved.
//

import Foundation

public struct Segment <T>: Sequence, IteratorProtocol
{
    var items: [T]
    var index: Int
    var last: Int

    public mutating func next() -> T? {
        guard index <= last else { return nil }
        defer { index += 1 }
        return items[index]
    }
    
    public init (_ items: [T], start: Int = 0, end: Int? = nil) {
        self.items = items
        self.index = start
        self.last = end ?? items.count - 1
    }
}
