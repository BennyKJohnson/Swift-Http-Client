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
    let session: NSURLSession!
    
      override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Accept":"application/json"];
        super.init();
        
        self.session = NSURLSession(configuration: config,
            delegate: self, delegateQueue: nil);
    }


   func fetchJSONFromURLWithDownload(url:NSURL) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    println("Fetching \(url.absoluteString)")
    
    let downloadTask = self.session.downloadTaskWithURL(url, completionHandler: { (location, response, error) -> Void in
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;

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
