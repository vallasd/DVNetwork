//    The MIT License (MIT)
//
//    Copyright (c) 2018 David C. Vallas (david_vallas@yahoo.com) (dcvallas@twitter)
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE

import Foundation

//--------------------------------------------------------------
// MARK: Casting
//--------------------------------------------------------------

infix operator -->

/// The ashcast: a better cast. Thanks Mike Ash
func --><T, U>(value: T, target: U.Type) -> U? {
    guard MemoryLayout<T>.size == MemoryLayout<U>.size else { return nil }
    return unsafeBitCast(value, to: target)
}

//--------------------------------------------------------------
// MARK: Postfix Printing
//--------------------------------------------------------------

postfix operator ***

/// Postfix printing for quick playground tests
public postfix func *** <T>(item: T) -> T {
    print(item); return item
}


//--------------------------------------------------------------
// MARK: Conditional Assignment
//--------------------------------------------------------------

infix operator =?

/// Conditionally assign optional value to target via unwrapping
/// Thanks, Mike Ash
func =?<T>(target: inout T, newValue: T?) {
    if let unwrapped = newValue { target = unwrapped }
}


//--------------------------------------------------------------
// MARK: In-Place Value Assignment
//--------------------------------------------------------------

infix operator <-

/// Replace the value of `a` with `b` and return the old value.
/// The EridiusAssignment courtesy of Kevin Ballard
public func <- <T>(a: inout T, b: T) -> T {
    var value = b; swap(&a, &value); return value
}

// --------------------------------------------------
// MARK: Chaining
// --------------------------------------------------

precedencegroup ChainingPrecedence {
    associativity: left
}

infix operator >>>: ChainingPrecedence

/// Failable chaining
public func >>><T, U>(x: T?, f: (T) -> U?) -> U? {
    if let x = x { return f(x) }
    return nil
}

/// Direct chaining
public func >>><T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}

//--------------------------------------------------------------
// MARK: Extended Initialization / Chaining
//--------------------------------------------------------------

infix operator •->

/// Prepare instance
func •-> <T>(object: T, f: (inout T) -> Void) -> T {
    var newValue = object
    f(&newValue)
    return newValue
}

//--------------------------------------------------------------
// MARK: Additional Operators
//--------------------------------------------------------------

precedencegroup ReplacePrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator ???: ReplacePrecedence

precedencegroup ChainFromRightPrecedence {
    associativity: right
    higherThan: AdditionPrecedence
}

infix operator <<<: ChainFromRightPrecedence

func <<< (lhs: inout AnyObject?, rhs: String) {
    if lhs is String { lhs = rhs as AnyObject?; return }
    lhs = nil
}

/*
 Usage note:
 Class:
 class MyClass {var (x, y, z) = ("x", "y", "z")}
 let myInstance = MyClass() •-> {
 $0.x = "NewX"
 $0.y = "NewY"
 }
 
 
 Struct:
 let myFoo = Foo() •-> {
 (inout item: Foo) in
 item.b = 23
 }
 */

