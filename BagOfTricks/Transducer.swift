//
//  Transducer.swift
//  BagOfTricks
//
//  Created by Jason Jobe on 8/29/16.
//  Copyright © 2016 WildThink. All rights reserved.
//

import Foundation
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 1</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <h2 id="transducers">Transducers</h2>
 <p>Transducers provide a nice way of efficiently processing arrays (and list-like types) by combining many operations into a single one. To illustrate this we will come up with a situation where the naive way of mapping and filtering an array of integers has some obvious flaws, and then look at how we can remedy it.</p>
 <p>Before we get to that we need to build up some tools to make function composition a little nicer. Afterall, bolstering function composition is one of the most important properties of functional programming. Here are a few simple combinators to start things off with:</p>

 </section>
 </div>
 </body>
 </html>

 */
import QuartzCore

// x |> f = f(x)
infix operator |> {associativity left}
func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

// (f |> g)(x) = f(g(x))
func |> <A, B, C> (f: (A) -> B, g: (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}

func measure(title: String!, call: () -> Void) {
    let startTime = CACurrentMediaTime()
    call()
    let endTime = CACurrentMediaTime()
    if let title = title {
        print("\(title): ")
    }
    print("Time - \(endTime - startTime)")
    //    let result:CFTimeInterval = endTime - startTime
    //    return result
}
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 3</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Using these combinators we can now be way more expressive with the flow of data:</p>

 </section>
 </div>
 </body>
 </html>

 */

/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 5</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>We will also re-define <code>map</code> to have a signature that is easier to work with:</p>

 </section>
 </div>
 </body>
 </html>

 */
func map <A, B> (f: (A) -> B) -> ([A]) -> [B] {
    return { $0.map(f) }
    //  return { map($0, f) }
}

/*
 extension SequenceType {
 /// Return the result of repeatedly calling `combine` with an
 /// accumulated value initialized to `initial` and each element of
 /// `self`, in turn, i.e. return
 /// `combine(combine(...combine(combine(initial, self[0]),
 /// self[1]),...self[count-2]), self[count-1])`.
 @warn_unused_result
 public func reduce<T>(initial: T, @noescape combine: (T, Self.Generator.Element) throws -> T) rethrows -> T
 }

 <S: SequenceType
 where S.Generator.Element: BooleanType>
 */
//[1, 2, 3].reduce(<#T##initial: T##T#>, combine: <#T##(T, Int) throws -> T#>)
// where E is  S.Generator.Element

//func reduce <T, S : CollectionType> (seq: S, initial: T, combine: (T, T) throws -> T) throws -> T {
func reduce<S: SequenceType>
    (seq: S, _ initial: S.Generator.Element, combine: (S.Generator.Element, S.Generator.Element) throws -> S.Generator.Element) rethrows -> S.Generator.Element {
    return try seq.reduce(initial, combine: combine)
}

//func reduce <A, B> (f: )

/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 7</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>This signature makes it clear that <code>map</code> simply lifts a function <code>A -&gt; B</code> to a function <code>[A] -&gt; [B]</code>. For example:</p>

 </section>
 </div>
 </body>
 </html>

 */
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 9</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Finally, we need to re-define <code>filter</code> just like we did for <code>map</code>:</p>

 </section>
 </div>
 </body>
 </html>

 */
func filter <A> (p: (A) -> Bool) -> ([A]) -> [A] {
    return {xs in
        var ys = [A]()
        for x in xs {
            if p(x) { ys.append(x) }
        }
        return ys
    }
}
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 11</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>This signature helps clarify that <code>filter</code> simply lifts a predicate <code>A -&gt; Bool</code> to a function on arrays <code>[A] -&gt; [A]</code>.</p>
 <p>Using these combinators and array processing functions we can do all types of fun stuff. Let&#39;s take a large array of integers and run them through a few functions:</p>

 </section>
 </div>
 </body>
 </html>

 */

func square (n: Int) -> Int {
    return n * n
}

func incr (n: Int) -> Int {
    return n + 1
}

/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 13</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>This isn&#39;t very efficient because we know that this will process the array of <code>xs</code> twice: once to <code>square</code> and again to <code>incr</code>. Instead we could compose <code>square</code> and <code>incr</code> once and feed that into <code>fmap</code>:</p>

 </section>
 </div>
 </body>
 </html>

 */
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 15</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Now we are simultaneously squaring and incrementing the <code>xs</code> in a single pass. What if we then wanted to <code>filter</code> that array of numbers to find all of the primes?</p>

 </section>
 </div>
 </body>
 </html>

 */
// Simple function to check primality of an integer. Details of this
// function aren't important, but it works.
func isPrime (p: Int) -> Bool {
    if p == 2 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }
    return true
}

/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 17</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>We&#39;re back to being inefficient again since we are processing the <code>xs</code> twice: once to <code>square</code> and <code>incr</code>, and again to check <code>isPrime</code>.</p>
 <p>Transducers aim to remedy this by collecting all mapping and filtering functions into a single function that can be run once to process the <code>xs</code>. The idea stems from the observation that most of the functions we write for processing arrays can actually be written in terms of <code>reduce</code>. (In fact, one can make a precise statement about <em>all</em> array functions being rewritten as <code>reduce</code>.) </p>
 <p>For example, here is how one might write <code>map</code>, <code>filter</code> and <code>take</code> in terms of <code>reduce</code>:</p>

 </section>
 </div>
 </body>
 </html>

 */
func map_from_reduce <A, B> (f: (A) -> B) -> ([A]) -> [B] {
    return {xs in
        return xs.reduce([]) { accum, x in accum + [f(x)] }
    }
}

func filter_from_reduce <A> (p: (A) -> Bool) -> ([A]) -> [A] {
    return {xs in
        return xs.reduce([]) { accum, x in
            return p(x) ? accum + [x] : accum
        }
    }
}

func take_from_reduce <A> (n: Int) -> ([A]) -> [A] {
    return {xs in
        return xs.reduce([]) { accum, x in
            return accum.count < n ? accum + [x] : accum
        }
    }
}

/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 19</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Now that we know <code>reduce</code> is in some sense &quot;universal&quot; among functions that process arrays we can try unifying all of our array processing under <code>reduce</code> and see if that aids in composition. To get to that point we are going to define some more things. First a term: given data types <code>A</code> and <code>C</code> we call a function of the form <code>(C, A) -&gt; C</code> a <strong>reducer</strong> on <code>A</code>. These are precisely the kinds of functions we could feed into <code>reduce</code>. The first argument is called the <strong>accumulation</strong> and the second element is just the element of the array being inspected. A function that takes a reducer on <code>A</code> and returns a reducer on <code>B</code> is called a <strong>transducer</strong>. A simple example would be the following:</p>

 </section>
 </div>
 </body>
 </html>

 */
func mapping <A, B, C> (f: (A) -> B) -> ((C, B) -> C) -> ((C, A) -> C) {
    return { reducer in
        return { accum, x in reducer(accum, f(x)) }
    }
}
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 21</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>It takes any function <code>A -&gt; B</code> and lifts it to a transducer from <code>B</code> to <code>A</code>. It is very important to note that the direction changed! This is called contravariance. Note that the implementation of this function is pretty much the only thing we could do to make it compile. It is almost as if the compiler is writing it for us. </p>
 <p>Another example:</p>

 </section>
 </div>
 </body>
 </html>

 */
func filtering <A, C> (p: (A) -> Bool) -> ((C, A) -> C) -> (C, A) -> C {
    return { reducer in
        return { accum, x in
            return p(x) ? reducer(accum, x) : accum
        }
    }
}
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 23</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>This lifts a predicate <code>A -&gt; Bool</code> to a transducer from <code>A</code> to <code>A</code>.</p>
 <p>We can use these functions to lift functions and predicates to transducers, and then feed them into <code>reduce</code>. In particular, consider <code>mapping(square)</code>. That lifts <code>square</code> to a transducer <code>((C, Int) -&gt; C) -&gt; ((C, Int) -&gt; C)</code>, where <code>C</code> can be any data type. If we feed a reducer into <code>mapping(square)</code> we get another reducer. A simple reducer that comes up often when dealing with arrays is <code>append</code>, which Swift doesn&#39;t have natively implemented but we can do easily enough:</p>

 </section>
 </div>
 </body>
 </html>

 */
func append <A> (xs: [A], x: A) -> [A] {
    return xs + [x]
}

/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 25</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Then what does <code>mapping(square)(append)</code> do? It just squares an integer and appends it to an array of integers.</p>

 </section>
 </div>
 </body>
 </html>

 */
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 27</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Feeding the reducer <code>mapping(square)(append)</code> into <code>reduce</code> we see that we get the same thing had we mapped with <code>square</code>:</p>

 </section>
 </div>
 </body>
 </html>

 */
//reduce(xs, [], mapping(square)(append))

/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 29</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Ok, but now we&#39;ve just made this code more verbose to seemingly accomplish the same thing. The reason to do this is because transducers are highly composable, whereas regular reducers are not. We can also do:</p>

 </section>
 </div>
 </body>
 </html>

 */
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 31</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Well, once again we didn&#39;t produce anything new that <code>map</code> didn&#39;t provide before. However, now we will mix in filters!</p>

 </section>
 </div>
 </body>
 </html>

 */
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 33</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>There we go. This is the first time we&#39;ve written something equivalently with <code>reduce</code> and <code>map</code>, but the <code>reduce</code> way resulted in processing the <code>xs</code> a single time, whereas the <code>map</code> way needed to iterate over <code>xs</code> twice. </p>
 <p>Let&#39;s add another wrinkle. Say we didn&#39;t just want those primes that are of the form <code>n*n+1</code> for <code>2 &lt;= n &lt;= 100</code>, but we wanted to find their sum. It&#39;s a very easy change:</p>

 </section>
 </div>
 </body>
 </html>

 */
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 35</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Now that looks pretty good! Some really terrific code reusability going on right there.</p>
 <p>Sometimes it&#39;s useful to truncate an array to the first <code>n</code> elements, especially when dealing with large data sets. How can we introduce truncation into our <code>reduce</code> processing pipeline? Well, we need another transducer. Given an integer and a reducer we need to construct a new reducer that simply accumulates until the accumulation has reached size <code>n</code>. Or in code:</p>

 </section>
 </div>
 </body>
 </html>

 */
func taking <A, C> (n: Int) -> (([C], A) -> [C]) -> (([C], A) -> [C]) {
    return { reducer in
        return { accum, x in
            return accum.count < n ? reducer(accum, x) : accum
        }
    }
}
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 37</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Note that this transducer is specialized in that it can only work with reducers of the type <code>([C], A) -&gt; [C]</code>, whereas our other transducers allowed for the more general case of <code>(C, A) -&gt; C</code>, i.e. the accumulation needs to be an array.</p>
 <p>Now say that we don&#39;t want to just find the primes of the form <code>n^2+1</code> for <code>2 &lt;= n &lt;= 100</code>. Say we want to find the first 10 <em>twin primes</em> of the form <code>n^2+1</code> (a <em>twin prime</em> is a prime <code>p</code> such that <code>p+2</code> is also prime). First we need a function for twin primality testing:</p>

 </section>
 </div>
 </body>
 </html>

 */
func isTwinPrime (p: Int) -> Bool {
    return isPrime(p) && isPrime(p+2)
}

func pr <T> (value: T) -> Bool {
    print (value)
    return true
}
/*: Convert this content to Playground Markup
 <!DOCTYPE html>
 <html>
 <head>
 <meta charset="utf-8">
 <title>Section 39</title>
 <meta id="xcode-display" name="xcode-display" content="render">
 <meta name="apple-mobile-web-app-capable" content="yes">
 <meta name="viewport" content="width=device-width, maximum-scale=1.0">
 <link rel="stylesheet" type="text/css" href="stylesheet.css">
 </head>
 <body>
 <div class="content-wrapper">
 <section class="section">
 <p>Then we can find the first 10 twin primes of the form <code>n^2+1</code> via:</p>

 </section>
 </div>
 </body>
 </html>

 */

