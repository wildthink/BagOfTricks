//
//  TimeIntervalExtension.swift
//  Pods
//
//  Created by Jason Jobe on 10/8/16.
//  Copyright © 2016 WildThink. All rights reserved.
//

import Foundation

public extension TimeInterval
{
    public var seconds: Double { return self }
    public var minutes: Double { return self * 60 }
    public var hours: Double   { return self.minutes * 60 }
    public var days: Double    { return self.hours * 24 }
    public var weeks: Double   { return self.days * 7 }
    public var months: Double  { return self.days * 30 }
    public var years: Double   { return self.days * 365 }

    public var second: Double { return self }
    public var minute: Double { return self * 60 }
    public var hour: Double   { return self.minutes * 60 }
    public var day: Double    { return self.hours * 24 }
    public var week: Double   { return self.days * 7 }
    public var month: Double  { return self.days * 30 }
    public var year: Double   { return self.days * 365 }

    public var in_seconds: Double { return self }
    public var in_minutes: Double { return self / 60 }
    public var in_hours: Double   { return self.in_minutes / 60 }
    public var in_days: Double    { return self.in_hours / 24 }
    public var in_weeks: Double   { return self.in_days / 7 }
    public var in_months: Double  { return self.in_days / 30 }
    public var in_years: Double   { return self.in_days / 365 }
    
}


public extension Int
{
    public var seconds: Double { return Double(self) }
    public var minutes: Double { return Double(self) * 60 }
    public var hours: Double   { return Double(self).minutes * 60 }
    public var days: Double    { return Double(self).hours * 24 }
    public var weeks: Double   { return Double(self).days * 7 }
    public var months: Double  { return Double(self).days * 30 }
    public var years: Double   { return Double(self).days * 365 }

    public var second: Double { return Double(self) }
    public var minute: Double { return Double(self) * 60 }
    public var hour: Double   { return Double(self).minutes * 60 }
    public var day: Double    { return Double(self).hours * 24 }
    public var week: Double   { return Double(self).days * 7 }
    public var month: Double  { return Double(self).days * 30 }
    public var year: Double   { return Double(self).days * 365 }

    public var in_seconds: Double { return Double(self) }
    public var in_minutes: Double { return Double(self) / 60 }
    public var in_hours: Double   { return Double(self).in_minutes / 60 }
    public var in_days: Double    { return Double(self).in_hours / 24 }
    public var in_weeks: Double   { return Double(self).in_days / 7 }
    public var in_months: Double  { return Double(self).in_days / 30 }
    public var in_years: Double   { return Double(self).in_days / 365 }
    
}
