//
//  Client.swift
//  Client
//
//  Created by Ben Johnson on 8/09/2014.
//  Copyright (c) 2014 Ben Johnson. All rights reserved.
//

import UIKit

class Client: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    let server = "http://google.com"
   private let session: NSURLSession!
    
    enum httpMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
      override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Accept":"application/json"];
        super.init();
        
        self.session = NSURLSession(configuration: config,
            delegate: self, delegateQueue: nil);
    }
    
    //Sends a Post Request to URL
    func sendPostRequestTo(url:String, httpHeaders : [String: String]? = nil, httpBody: NSData? = nil) {
        fetchJSONFromURLWith(NSURL(string: url), httpMeth: .POST, httpHeaders: httpHeaders, httpBody: httpBody)
    }
    //Sends a Get Request to URL, set Download to true if request is returning a document
    func sendGetRequestTo(url:String,isDownload:Bool, httpHeaders: [String: String]? = nil, httpBody: NSData? = nil) {
        if(isDownload) {
            fetchJSONFromURLWithDownload(NSURL(string: url))
        }
        else {
            fetchJSONFromURLWith(NSURL(string: url), httpHeaders: httpHeaders, httpBody: httpBody)
        }
    }
   private func getURLWith(append: String) -> NSURL {
        return NSURL(string: server + append)
    }
    
   private func initialiseRequest(url :NSURL) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        println("Fetching \(url.absoluteString)")

    }
    
   private func deinitRequest() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
 
    private func fetchJSONFromURLWith(url:NSURL, httpMeth: httpMethod = .GET, httpHeaders : [String: String]?, httpBody: NSData?) {
        var request = NSMutableURLRequest(URL: url)
        if let headers = httpHeaders {
            for (key,value) in headers {
                request.addValue(value,forHTTPHeaderField: key);
            }
        
        }
        
        request.HTTPMethod = httpMeth.toRaw()
        if (httpMeth == httpMethod.POST && httpBody != nil) {
            if let postData = NSJSONSerialization.dataWithJSONObject(httpBody!, options: nil, error: nil) {
                request.HTTPBody = postData;
            }
        }
        
        let dataTask = session.dataTaskWithRequest(request)
        initialiseRequest(url)
        dataTask.resume()
    }

    
   private func fetchJSONFromURLWithDownload(url:NSURL) {
    
    initialiseRequest(url)
    let downloadTask = self.session.downloadTaskWithURL(url, completionHandler: { (location, response, error) -> Void in
        self.deinitRequest()
        var statusCode = 400;
        if let resp = response as? NSHTTPURLResponse {
            statusCode = resp.statusCode
        }
        if (error != nil) {
            println("Oh Shit! NSERROR for downloadTask")
        }
        else if (statusCode >= 400)
        {
             println("Oh Shit! HTTP Error \(statusCode) for downloadTask")
        }
        else {
            var readError: NSError?
            let data = NSData.dataWithContentsOfURL(url, options: nil, error: &readError)
            
            if let errorValue = readError {
                println("Read Error Occured: \(errorValue)")
            }
            else if let jsonData: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &readError)
            {
                    println("\(jsonData)")
                    //We have data
                    //Should Send it
            }
            else
            {
                println("Oh Shit! Error for downloadTask")
 
                
            }
        }
        
    })
    downloadTask.resume();
    }
    
    
    
    
}
