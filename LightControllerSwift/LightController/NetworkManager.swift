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
    var hostIp = "10.0.1.43"
    

    func sendGetRequest ( path:String )
    {
//        let requestString = self.ipString + "greenOn";
//        NSLog( "Sending request: %@", requestString );
//
//        let requestURL = NSURL(string:requestString)!
//
//        let request = NSMutableURLRequest(URL: requestURL)
//        request.HTTPMethod = "GET"
//
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request)
//        task.resume()
    }
    
    func sendGetRequest2 ( path:String )
    {
        let requestString = self.ipString + path;
        print( "Sending request: \(requestString)" )
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = self.hostIp
        urlComponents.port = 3000
        urlComponents.path = "/" + path
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if ( responseError != nil )
            {
                print( "Error: \(String(describing: responseError))" );
            }
        }

        task.resume()
    }
    
    
    func sendGetRequest3 ( path:String, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void )
    {
        let userId = "0001"
        
        let requestString = self.ipString + path
        print( "Sending request: \(requestString)" )

        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = self.hostIp
        urlComponents.port = 3000
        urlComponents.path = "/" + path
        
        let userIdItem = URLQueryItem(name: "userId", value: "\(userId)")
        urlComponents.queryItems = [userIdItem]
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        
        task.resume()
    }
    
    
    func sendPostRequest ( path:String, params: Dictionary<String, String> )
    {
        let requestString = self.ipString + path
        print( "Sending POST request: \(requestString)" )
        
        guard let jsonData = try? JSONSerialization.data( withJSONObject: params, options: [] ) else
        {
            print ("Cound not serialize param dictionary." )
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = self.hostIp
        urlComponents.port = 3000
        urlComponents.path = "/" + path
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if ( responseError != nil )
            {
                print( "Error: \(String(describing: responseError))" );
            }
        }
        
        task.resume()
        
//        let requestString = self.ipString + path;
//        NSLog( "Sending request: %@", requestString );
//
//        var body : NSData? = nil;
//        do
//        {
//            body = try NSJSONSerialization.dataWithJSONObject( params, options: [] )
//
//        } catch
//        {
//            print("Dim background error")
//        }
//
//        print ( "data: \(body)" );
//
//        let url : NSURL = NSURL(string: requestString)!
//        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url )
//        request.HTTPMethod = "POST"
//        request.HTTPBody = body
//        request.setValue( "application/json", forHTTPHeaderField:"Content-Type" )
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: config)
//
//        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error : NSError?) in
//
//            if ( error != nil )
//            {
//                print( "Error: \(error)" );
//            }
//
//            // notice that I can omit the types of data, response and error
//
//            // your code
//
//        });
//
//        task.resume()
    }
}
