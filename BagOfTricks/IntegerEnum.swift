//
//  IntegerEnum.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 8/21/16.
//  Copyright © 2016 WildThink. All rights reserved.
//
import Foundation
// Distilation of ideas and examples from these great contributions to the community
// http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type
// https://forums.developer.apple.com/thread/4404
// https://www.natashatherobot.com/swift-conform-to-sequence-protocol/

public protocol IntegerEnum {
    init? (rawValue: Int)
    static var firstRawValue: Int { get }
}

public extension IntegerEnum {

    static var firstRawValue: Int { return 0 }

    static var sequence: AnyIterator<Self> {
        var lastIteration = firstRawValue

        return AnyIterator {
            lastIteration += 1
            return Self(rawValue: lastIteration - 1)
        }
    }
}

/** Example Use

enum Suit: Int, IntegerEnum {
    case Hearts, Clubs, Diamonds, Spades
}

enum Size: Int, IntegerEnum {
    case Small, Medium, Large
}

for s in Suit.sequence {
    print (s)
}

for s in Size.sequence {
    print (s)
}

let a = Array(Suit.sequence) // [Hearts, Clubs, Diamonds, Spades]
Size.sequence.reverse()     //  [Large, Medium, Small]

*/
