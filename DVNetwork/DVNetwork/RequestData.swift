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

public typealias RequestDict = Dictionary<String, String>

public enum HttpMethod {
    case get
    case post
    case put
    case delete
    
    var string: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

/// Data set used to create URLRequests for DVNetwork.
public struct RequestData {
    
    let baseURL: String
    let httpMethod: HttpMethod?
    let timeout: Double
    let pagingData: PagingData?
    let headers: RequestDict
    let parameters: RequestDict
    
    public init(baseURL bu: String, httpMethod http: HttpMethod?, timeout t: Double, pagingData pd: PagingData?, headers h: RequestDict, parameters p: RequestDict) {
        baseURL = bu
        httpMethod = http
        timeout = t
        pagingData = pd
        headers = h
        parameters = p
    }
    
    public init(baseURL bu: String) {
        baseURL = bu
        httpMethod = .get
        timeout = 5.0
        pagingData = nil
        headers = [:]
        parameters = [:]
    }
    
    public init(baseURL bu: String, method m: HttpMethod, headers h: RequestDict, parameters p: RequestDict) {
        baseURL = bu
        httpMethod = m
        timeout = 5.0
        pagingData = nil
        headers = h
        parameters = p
    }
    
    public init(baseURL bu: String, perPage: Int) {
        baseURL = bu
        httpMethod = .get
        timeout = 5.0
        pagingData = PagingData(current: 1, last: 1, per: perPage)
        headers = [:]
        parameters = [:]
    }
    
    public init(baseURL bu: String, pagingData pd: PagingData) {
        baseURL = bu
        httpMethod = .get
        timeout = 5.0
        pagingData = pd
        headers = [:]
        parameters = [:]
    }
    
    /// Adds a PageingData to the RequestData
    func create(withPagingData: PagingData?) -> RequestData {
        
        return RequestData(baseURL: baseURL,
                           httpMethod: httpMethod,
                           timeout: timeout,
                           pagingData: withPagingData,
                           headers: headers,
                           parameters: parameters)
    }
    
    /// Increments the PagingData by one in a RequestData (if PagingData exists)
    var incrementPage: RequestData {
        let newPD = pagingData?.increment
        let newRequestData = RequestData(baseURL: baseURL,
                                         httpMethod: httpMethod,
                                         timeout: timeout,
                                         pagingData: newPD,
                                         headers: headers,
                                         parameters: parameters)
        return newRequestData
    }
    
    /// Creates a URLRequest for the RequestData.  If a request can not be created, returns an Error.
    var urlRequest: DVResult<URLRequest> {
        
        var urlString = baseURL
        
        for key in parameters.keys {
            urlString = urlString.addParameterSeperator
            let value = parameters[key].string
            urlString = urlString + "\(key)=\(value)"
        }
        
        // add per_page if needed
        if let p = pagingData?.per, p > 0 {
            urlString = urlString.addParameterSeperator
            urlString = urlString + "per_page=\(p)"
        }
        
        // add page if needed
        if let c = pagingData?.current, c > 0 {
            urlString = urlString.addParameterSeperator
            urlString = urlString + "page=\(c)"
        }
        
        // return error if url can not be created
        guard let url = URL(string: urlString) else {
            let error = NSError.createURL(urlString)
            return .error(error)
        }
        
        // create urlreqeust
        let request = NSMutableURLRequest(url: url)
        
        // add headers if necessary
        for key in headers.keys {
            request.addValue(headers[key].string, forHTTPHeaderField: key)
        }
        
        // define httpMethod
        if let method = httpMethod {
            request.httpMethod = method.string
        }
        
        // define timeout interval
        request.timeoutInterval = Double(timeout)
        
        // copy it to a URL Request
        let r = request.copy() as! URLRequest
        
        return .value(r)
    }
}
