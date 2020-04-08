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

public typealias JSON = Any
public typealias DICT = Dictionary<String, Any>
public typealias ARRAY = [DICT]

public class DVDecode {
    
    /// Returns an DVDICT.  If DVDICT can not be unwrapped as DVDICT, produces an error message and returns an empty DVDICT.
    public static func decode<T>(dvdict: Any, decoder: T) -> DICT {
        if let dict = dvdict as? DICT { return dict }
        DVReport.shared.decodeFailed(decoder, object: dvdict)
        return DICT()
    }
    
    /// Returns an DVARRAY.  If DVARRAY can not be unwrapped as DVARRAY, produces an error message and returns an empty DVARRAY.
    public static func decode<T>(dvarray: Any, decoder: T) -> ARRAY {
        if let array = dvarray as? ARRAY { return array }
        DVReport.shared.decodeFailed(decoder, object: dvarray)
        return ARRAY()
    }
    
}
