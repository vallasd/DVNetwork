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

/// This class performs URL Requests.  Will return Results on main thread if processNetworkCompletionHandlersOnMainThread is set to true.  DVNetwork folder is dependent on DVCodable, DVReport and DVFunctional folders.
public class DVNetwork {
    
    public static let shared = DVNetwork()

    public var processNetworkCompletionHandlersOnMainThread = true
    
    // MARK: - Public Functions
    
    /// Performs multiple requests based off of PagingData in RequestData.  Will attempt to determine PagingData and return this info to the user with array of DVCodable Objects or Error.  Completion handler will be called for each request called.  If current page is 1, last page is 5 in page data, 1,2,3,4,5 completion times will be called.  If pagingData is nil in RequestData, request will be created without the paging data and run once.
    public func performRequest<A: DVCodable>(requestData: RequestData, completion: @escaping (DVResultWithPagingData<[A]>) -> ()) {
        
        // If pagingData in requestData is nil, we will make a dummy paging.  Dummy page will not be processed in request.
        var pagingData = requestData.pagingData != nil ? requestData.pagingData : PagingData()
        
        while pagingData != nil {
            
            let newRequestData = requestData.create(withPagingData: pagingData!)
            let result: DVResult<URLRequest> = newRequestData.urlRequest
            
            switch result {
            case let .value(request):
                performRequest(request: request, completion: { [weak self] (result) in
                    self?.process(result: result, completion: completion)
                })
            case let .error(error):
                let errorResult: DVResultWithPagingData<[A]> = DVResultWithPagingData(error)
                completion(errorResult)
            }
            
            pagingData = pagingData?.increment
        }
    }
    
    /// Performs multiple requests based off of PagingData in RequestData.  Will return result as DVCodable Object or Error.  Completion handler will be called for each request called.  If current page is 1, last page is 5 in page data, 1,2,3,4,5 completion times will be called.  If pagingData is nil in RequestData, request will be created without the paging data and run once.
    public func performRequest<A: DVCodable>(requestData: RequestData, completion: @escaping (DVResult<A>) -> ()) {
        
        // If pagingData in requestData is nil, we will make a dummy paging.  Dummy page will not be processed in request.
        var pagingData = requestData.pagingData != nil ? requestData.pagingData : PagingData()
        
        while pagingData != nil {
            
            let newRequestData = requestData.create(withPagingData: pagingData!)
            let result: DVResult<URLRequest> = newRequestData.urlRequest
            
            switch result {
            case let .value(request):
                performRequest(request: request, completion: { [weak self] (result) in
                    self?.process(result: result, completion: completion)
                })
            case let .error(error):
                let errorResult: DVResult<A> = resultFromOptional(optional: nil, error: error)
                completion(errorResult)
            }
            
            pagingData = pagingData?.increment
        }
    }
    
    /// Performs multiple requests based off of PagingData in RequestData.  Will return result as array of DVCodable Objects or Error.  Completion handler will be called for each request called.  If current page is 1, last page is 5 in page data, 1,2,3,4,5 completion times will be called.  If pagingData is nil in RequestData, request will be created without the paging data and run once.
    public func performRequest<A: DVCodable>(requestData: RequestData, completion: @escaping (DVResult<[A]>) -> ()) {
        
        // If pagingData in requestData is nil, we will make a dummy paging.  Dummy page will not be processed in request.
        var pagingData = requestData.pagingData != nil ? requestData.pagingData : PagingData()
        
        while pagingData != nil {
            
            let newRequestData = requestData.create(withPagingData: pagingData!)
            let result: DVResult<URLRequest> = newRequestData.urlRequest
            
            switch result {
            case let .value(request):
                performRequest(request: request, completion: { [weak self] (result) in
                    self?.process(result: result, completion: completion)
                })
            case let .error(error):
                let errorResult: DVResult<[A]> = resultFromOptional(optional: nil, error: error)
                completion(errorResult)
            }
            
            pagingData = pagingData?.increment
        }
    }
    
    /// Performs a request for URLRequest.  Will return a DVCodable Object or Error.
    func performRequest<A: DVCodable>(request: URLRequest, completion: @escaping (DVResult<A>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let s = self else { return }
            let result: DVResult<A> = s.parseResult(data: data, urlResponse: urlResponse, error: error)
            s.process(result: result, completion: completion)
        }
        task.resume()
    }
    
    /// Performs a request for URLRequest.  Will return an array of DVCodable Objects or Error.
    func performRequest<A: DVCodable>(request: URLRequest, completion: @escaping (DVResult<[A]>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let s = self else { return }
            let result: DVResult<[A]> = s.parseResult(data: data, urlResponse: urlResponse, error: error)
            s.process(result: result, completion: completion)
        }
        task.resume()
    }
    
    /// Performs a request for URLRequest.  Will an array of DVCodable Objects with optional PagingData (if it can be determined) or Error.
    func performRequest<A: DVCodable>(request: URLRequest, completion: @escaping (DVResultWithPagingData<[A]>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let s = self else { return }
            var result: DVResultWithPagingData<[A]> = s.parseResult(data: data, urlResponse: urlResponse, error: error)
            result = s.resultWithPagingData(result: result, request: request)
            s.process(result: result, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - Private Functions
    
    /// Attempts to decode JSON into a DVCodable Object.  Returns object or Error.
    fileprivate func parseResult<A: DVCodable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> DVResult<A> {
        let responseResult: DVResult<Data> = result(data: data, urlResponse: urlResponse, error: error)
        return responseResult >>> decodeJSON >>> decodeObject
    }
    
    /// Attempts to decode JSON into an array of DVCodable Objects.  Returns array of objects or Error.
    fileprivate func parseResult<A: DVCodable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> DVResult<[A]> {
        let responseResult: DVResult<Data> = result(data: data, urlResponse: urlResponse, error: error)
        return responseResult >>> decodeJSON >>> decodeObject
    }
    
    /// Attempts to decode JSON into an array of DVCodable Objects.  Returns array objects with optional PagingData or Error.
    fileprivate func parseResult<A: DVCodable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> (DVResultWithPagingData<[A]>) {
        let result: DVResult<[A]> = parseResult(data: data, urlResponse: urlResponse, error: error)
        let pd = PagingData.pagingData(urlResponse: urlResponse) ?? PagingData.pagingData(data: data)
        let resultWithPagingData = DVResultWithPagingData(result, pagingData: pd)
        return resultWithPagingData
    }
    
    /// Processes completion handler.  (On main thread if processNetworkCompletionHandlersOnMainThread is set to true)
    fileprivate func process<A: DVCodable>(result: DVResultWithPagingData<[A]>, completion: @escaping (DVResultWithPagingData<[A]>) -> ()) {
        if processNetworkCompletionHandlersOnMainThread {
            DispatchQueue.main.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }
    
    /// Processes completion handler.  (On main thread if processNetworkCompletionHandlersOnMainThread is set to true)
    fileprivate func process<A: DVCodable>(result: DVResult<A>, completion: @escaping (DVResult<A>) -> ()) {
        if processNetworkCompletionHandlersOnMainThread {
            DispatchQueue.main.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }
    
    /// Processes completion handler.  (On main thread if processNetworkCompletionHandlersOnMainThread is set to true)
    fileprivate func process<A: DVCodable>(result: DVResult<[A]>, completion: @escaping (DVResult<[A]>) -> ()) {
        if processNetworkCompletionHandlersOnMainThread {
            DispatchQueue.main.async {
                completion(result)
            }
        } else {
            completion(result)
        }
    }
    
    /// This function tries to update the per page count for a result if we weren't able to find it before
    fileprivate func resultWithPagingData<A: DVCodable>(result: DVResultWithPagingData<[A]>, request: URLRequest) -> DVResultWithPagingData<[A]> {
        
        switch result {
        case let .value(x):
            if let pagingData = x.pagingData {
                if pagingData.per == 0 {
                    
                    // check request url to try to attain per page count
                    if let perPage = request.url?.absoluteString.perPage {
                        let newPD = pagingData.update(per: perPage)
                        return DVResultWithPagingData(result, pagingData: newPD)
                    }
                    
                    // use count of objects to attain per page
                    if x.value.count != 0 {
                        let newPD = pagingData.update(per: x.value.count)
                        return DVResultWithPagingData(result, pagingData: newPD)
                    }
                    
                    // we still have a 0 count for per page, so we dont return any paging data
                    return DVResultWithPagingData(result, pagingData: nil)
                }
            }
            return result
        case .error:
            return result
        }
    }
    
    /// Processes data, urlResponse, and error sent back from a request and either returns the data or an Error in the Result.
    fileprivate func result(data: Data?, urlResponse: URLResponse?, error: Error?) -> DVResult<Data> {
        
        // return error if there is one
        if let e = error {
            return .error(e)
        }
        
        // get localized error, if response status code is not a successful one
        if let httpResponse = urlResponse as? HTTPURLResponse {
            let code = httpResponse.statusCode
            let successRange = 200..<300
            if !successRange.contains(code) {
                let message = HTTPURLResponse.localizedString(forStatusCode: code)
                let error = NSError.error(message: message, code: code)
                return .error(error)
            }
        }
        
        // return data if some is received and there were no errors or bad responses
        if let d = data {
            return .value(d)
        }
        
        // return generic error, if data was nil
        return .error(NSError.dataError)
    }

    
    
}
