//
//  ViewController.swift
//  LightController
//
//  Created by Konstantin Yavichev on 12/31/15.
//  Copyright © 2015 BumperHeads. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate
{
    static var ipString = "http://10.0.1.10:3000/"
    
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.urlTextField.delegate = self;
        
        NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(ViewController.checkHeartBeat), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkHeartBeat()
    {
        NSLog("Checking heartbeat")
        
//        var completionHandler:(String)->Void = {
//            (path:String) -> Void in
//            NSLog( "Poop deck" );
//        }
        
        
        
        let completionHandler:(NSData?, NSURLResponse?, NSError?) -> Void = { (data, response, error:NSError?) in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print("error \(httpResponse.statusCode)")
            }
            
            if ( error != nil )
            {
                NSLog ( "Cannot connect" )
                print( "Error: \(error)" )
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.connectionLabel.text = "not connected"
                })
                
            }
            else
            {
                NSLog ( "Connected" )
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.connectionLabel.text = "connected"
                })
            }
        }
        
        self.sendGetRequest3( "heartBeat", completionHandler:completionHandler)
    }
    
    
    @IBAction func urlTextFieldFinishedEditting(textField: UITextField)
    {
        NSLog( "New value: " + textField.text! )
        ViewController.ipString = "http://" + textField.text! + "/"
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func redOnButton(sender: UIButton)
    {
        NSLog( "Red On Button!" );
        self.sendGetRequest2( "redOn" );
    }
    
    @IBAction func redHalfButton(sender: UIButton)
    {
        NSLog( "Red Half Button!" );
        self.sendGetRequest2( "redHalf" );
    }
    
    @IBAction func redOffButton(sender: UIButton)
    {
        NSLog( "Red Off Button!" );
        self.sendGetRequest2( "redOff" );
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider)
    {
        NSLog( "Red Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        self.sendPostRequest( "redValue/", params: params )
    }
    
    @IBAction func greenOnButton(sender: UIButton)
    {
        NSLog( "Green On Button!" );
        self.sendGetRequest2( "greenOn" );
    }
    
    @IBAction func greenHalfButton(sender: UIButton)
    {
        NSLog( "Green Half Button!" );
        self.sendGetRequest2( "greenHalf" );
    }
    
    @IBAction func greenOffButton(sender: UIButton)
    {
        NSLog( "Green Off Button!" );
        self.sendGetRequest2( "greenOff" );
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider)
    {
        NSLog( "Green Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        self.sendPostRequest( "greenValue/", params: params )
    }
    
    @IBAction func blueOnButton(sender: UIButton)
    {
        NSLog( "Blue On Button!" );
        self.sendGetRequest2( "blueOn" );
    }
    
    @IBAction func blueOffButton(sender: UIButton)
    {
        NSLog( "Blue Off Button!" );
        self.sendGetRequest2( "blueOff" );
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider)
    {
        NSLog( "Blue Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        self.sendPostRequest( "blueValue/", params: params )
    }
    
    @IBAction func fadeButton(sender: UIButton)
    {
        NSLog( "Fade Button!" );
        self.sendGetRequest2( "fade" );
    }
    
    @IBAction func allOnButton(sender: UIButton)
    {
        NSLog( "All On Button!" );
        self.sendGetRequest2( "allOn" );
    }
    
    @IBAction func allOffButton(sender: UIButton)
    {
        NSLog( "All Off Button!" );
        self.sendGetRequest2( "allOff" );
    }
    
    
    func sendGetRequest ( path:String )
    {
        let requestString = ViewController.ipString + "greenOn";
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
        let requestString = ViewController.ipString + path;
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
        let requestString = ViewController.ipString + path
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
        let requestString = ViewController.ipString + path;
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
//    
//    func sendHeartBeatRequest ()
//    {
//        let requestString = ViewController.ipString + "heartbeat";
//        NSLog( "Sending request: %@", requestString );
//        
//        let url : NSURL = NSURL(string: requestString)!
//        let request: NSURLRequest = NSURLRequest(URL: url)
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
//    }
}

