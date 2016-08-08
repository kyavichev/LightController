//
//  NetworkManager.swift
//  LightController
//
//  Created by Konstantin Yavichev on 8/7/16.
//  Copyright © 2016 BumperHeads. All rights reserved.
//

import Foundation


class NetworkManager
{
    static let sharedInstance = NetworkManager()
    
    var ipString = "http://10.0.1.10:3000/"
    

    func sendGetRequest ( path:String )
    {
        let requestString = self.ipString + "greenOn";
        NSLog( "Sending request: %@", requestString );
        
        let requestURL = NSURL(string:requestString)!
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request)
        task.resume()
    }
    
    func sendGetRequest2 ( path:String )
    {
        let requestString = self.ipString + path;
        NSLog( "Sending request: %@", requestString );
        
        let url : NSURL = NSURL(string: requestString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error : NSError?) in
            
            if ( error != nil )
            {
                print( "Error: \(error)" );
            }
            
            // notice that I can omit the types of data, response and error
            
            // your code
            
        });
        
        task.resume()
    }
    
    
    func sendGetRequest3 ( path:String, completionHandler:(NSData?, NSURLResponse?, NSError?) -> Void )
    {
        let requestString = self.ipString + path
        NSLog( "Sending request: %@", requestString );
        
        let url : NSURL = NSURL(string: requestString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: completionHandler );
        
        task.resume()
    }
    
    
    func sendPostRequest ( path:String, params: Dictionary<String, String> )
    {
        let requestString = self.ipString + path;
        NSLog( "Sending request: %@", requestString );
        
        var body : NSData? = nil;
        do
        {
            body = try NSJSONSerialization.dataWithJSONObject( params, options: [] )
            
        } catch
        {
            print("Dim background error")
        }
        
        print ( "data: \(body)" );
        
        let url : NSURL = NSURL(string: requestString)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url )
        request.HTTPMethod = "POST"
        request.HTTPBody = body
        request.setValue( "application/json", forHTTPHeaderField:"Content-Type" )
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error : NSError?) in
            
            if ( error != nil )
            {
                print( "Error: \(error)" );
            }
            
            // notice that I can omit the types of data, response and error
            
            // your code
            
        });
        
        task.resume()
    }
}
