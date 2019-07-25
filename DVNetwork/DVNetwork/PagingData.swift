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

/// PagingData is used to iterate through requests which contain more than one page.
public struct PagingData {
    
    let current: Int
    let previous: Int?
    let next: Int?
    let last: Int
    let per: Int
    
    public init(current c: Int, last l: Int, per p: Int) {
        current = max(c, 1)
        last = l < current ? current : l
        next = current == last ? nil : current + 1
        previous = current == 1 ? nil : current - 1
        per = max(0,p)
    }
    
    // Creates a dummy file that won't be processed when creating requests (no paging information made when creating a URLRequest)
    public init() {
        current = 0
        last = 0
        next = 0
        previous = 0
        per = 0
    }
    
    /// Determines the starting items index for the current page. (assuming you loaded all pages before the current page)
    public var startingItemIndex: Int {
        let c = max(current - 1, 0)
        return c * per
    }
    
    /// Creates an stack array of PagingDatas, current page being at top of stack.
    public var indexedPages: [PagingData] {
        
        var l = last
        var indexedPages: [PagingData] = []
        
        while l >= current {
            let indexedPage = PagingData(current: l, last: l, per: per)
            indexedPages.append(indexedPage)
            l -= 1
        }
        
        return indexedPages
    }
    
    /// Estimates the items left to download based on current page, last page, and items per page.
    public var itemsLeftToDownload: Int {
        let itemsLeft = (last + 1 - current) * per
        return itemsLeft > 0 ? itemsLeft : 0
    }
    
    /// returns new pagingData for next page. If current page is last page, returns nil
    public var increment: PagingData? {
        if current == last { return nil }
        return PagingData(current: max(current + 1, 1), last: last, per: per)
    }
    
    /// returns new pagingData for previous page.  If current page is first page, returns nil.
    public var decrement: PagingData? {
        if current == 1 { return nil }
        return PagingData(current: max(current - 1, 1), last: last, per: per)
    }
    
    /// returns a PagingData with an update per value
    public func update(per: Int) -> PagingData {
        return PagingData(current: self.current,
                          last: self.last,
                          per: per)
    }
    
    /// Attempts to create PagingData from a URLResponse.
    static func pagingData(urlResponse: URLResponse?) -> PagingData? {
        
        // attempts to determine PagingData from the header field Link (Github paging)
        if let httpResponse = urlResponse as? HTTPURLResponse {
            if let links = httpResponse.allHeaderFields["Link"] as? String {
                let pd = links.githubPagingData
                return pd
            }
        }
        
        return nil
    }
    
    /// Attempts to create PagingData from a Data file.
    static func pagingData(data: Data?) -> PagingData? {
        
        if let d = data {
            do {
                let json = try JSONSerialization.jsonObject(with: d, options: [.allowFragments])
                if let j = json as? DVDICT {
                    
                    // attempt to create paging data (Flickr paging)
                    if let photos = j["photos"] as? DVDICT {
                        let current = photos["page"].int
                        let last = photos["pages"].int
                        let per = photos["perpage"].int
                        return PagingData(current: current,
                                          last: last,
                                          per: per)
                    }
                }
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    
}
