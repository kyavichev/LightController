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
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var redColorLabel: UILabel!
    @IBOutlet weak var greenColorLabel: UILabel!
    @IBOutlet weak var blueColorLabel: UILabel!
    
    @IBOutlet weak var redSlider : UISlider!
    @IBOutlet weak var greenSlider : UISlider!
    @IBOutlet weak var blueSlider : UISlider!
    
    var fadeViewController : FadeTabViewController!
    
    
    var isRedSliderDragged : Bool!
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // delegates
        self.urlTextField.delegate = self;
        
        // find controllers
        let barViewControllers = self.tabBarController?.viewControllers
        self.fadeViewController = barViewControllers![1] as? FadeTabViewController
        
        // defaults
        self.isRedSliderDragged = false;
        
        // system defaults
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for:[])
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for:.selected)
//
//        let attributes: [String: AnyObject] = [NSFontAttributeName:UIFont(name: "Arial", size: 16)!, NSForegroundColorAttributeName: UIColor.gray]
//        UITabBarItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(checkHeartBeat), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getStatus), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func checkHeartBeat()
    {
        print("Checking heartbeat")
        
//        var completionHandler:(String)->Void = {
//            (path:String) -> Void in
//            NSLog( "Poop deck" );
//        }
        
        
        
        let completionHandler:(Data?, URLResponse?, Error?) -> Void = { (data, response, error:Error?) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
            }
            
            if ( error != nil )
            {
                print ( "Cannot connect" )
                print( "Error: \(String(describing: error))" )
                
                DispatchQueue.main.async {
                    self.connectionLabel.text = "not connected"
                }
            }
            else
            {
                NSLog ( "Connected" )
                
                DispatchQueue.main.async {
                    self.connectionLabel.text = "connected"
                }
            }
        }
        
        NetworkManager.sharedInstance.sendGetRequest3( path: "heartBeat", completionHandler:completionHandler)
    }
    
    
    @objc func getStatus ()
    {
        print( "Getting colors" )
        
        let completionHandler:(Data?, URLResponse?, Error?) -> Void = { (data, response, error:Error?) in
            

            
            if let httpResponse = response as? HTTPURLResponse
            {
                print("error \(httpResponse.statusCode)")
            }
            
            if ( error != nil )
            {
                print( "Could not get colors. Error: \(String(describing: error))" )
                
                DispatchQueue.main.async {
                    self.connectionLabel.text = "not connected"
                }
            }
            else
            {
                let httpResponse = response as? HTTPURLResponse
                
                print ("error \(httpResponse!.statusCode)")
                print ( "Got colors:" )
                
                if (httpResponse!.statusCode != 200)
                {
                    print ( "Issues issues issues" )
                    return
                }
                
                //let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let data = data else
                {
                    return
                }
                
                let responseData = String(data: data, encoding: String.Encoding.utf8)
                print( responseData )
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else
                {
                    print ("Cound generate json" )
                    return
                }

                guard let jsonMap = json as? [String: Any] else
                {
                    print ( "Could not json data" )
                    return
                }
                
                guard let jsonDataMap = jsonMap[ "data" ] as? [String: Any] else
                {
                    print ( "JSON root is not \'data\'" )
                    return
                }

                let red = (jsonDataMap[ "red" ] as! NSNumber).intValue //as! Int
                let green = (jsonDataMap[ "green" ] as! NSNumber).intValue
                let blue = (jsonDataMap[ "blue" ] as! NSNumber).intValue
                let colorStep = (jsonDataMap[ "colorStep" ] as! NSNumber).floatValue

                let fadeRedModifierValue = (jsonDataMap[ "fadeRedModifier" ] as! NSNumber).floatValue
                let fadeGreenModifierValue = (jsonDataMap[ "fadeGreenModifier" ] as! NSNumber).floatValue
                let fadeBlueModifierValue = (jsonDataMap[ "fadeBlueModifier" ] as! NSNumber).floatValue

                let deviceColor = UIColor.init( red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1 )

                
                DispatchQueue.main.async {
                    self.view.backgroundColor = deviceColor

                    self.redColorLabel.text = String( red )
                    self.greenColorLabel.text = String( green )
                    self.blueColorLabel.text = String( blue )

                    if ( !self.isRedSliderDragged )
                    {
                        self.redSlider.value = Float ( (jsonDataMap[ "red" ] as! NSNumber).floatValue / 255.0 )
                    }

                    self.greenSlider.value = Float ( (jsonDataMap[ "green" ] as! NSNumber).floatValue / 255.0 )
                    self.blueSlider.value = Float ( (jsonDataMap[ "blue" ] as! NSNumber).floatValue / 255.0 )

                    if ( self.fadeViewController.view != nil )
                    {
                        self.fadeViewController.view.backgroundColor = deviceColor
                    }

                    if ( self.fadeViewController.colorStepSlider != nil )
                    {
                        self.fadeViewController.colorStepSlider.value = colorStep
                    }
                    if ( self.fadeViewController.colorStepLabel != nil )
                    {
                        self.fadeViewController.colorStepLabel.text = "\(colorStep)"
                    }

                    if ( self.fadeViewController.fadeRedModifierSlider != nil )
                    {
                        self.fadeViewController.fadeRedModifierSlider.value = fadeRedModifierValue;
                    }
                    if ( self.fadeViewController.fadeRedModifierLabel != nil )
                    {
                        self.fadeViewController.fadeRedModifierLabel.text = "\(fadeRedModifierValue)"
                    }
                    if ( self.fadeViewController.fadeGreenModifierSlider != nil )
                    {
                        self.fadeViewController.fadeGreenModifierSlider.value = fadeGreenModifierValue
                    }
                    if ( self.fadeViewController.fadeGreenModifierLabel != nil )
                    {
                        self.fadeViewController.fadeGreenModifierLabel.text = "\(fadeGreenModifierValue)"
                    }
                    if ( self.fadeViewController.fadeBlueModifierSlider != nil )
                    {
                        self.fadeViewController.fadeBlueModifierSlider.value = fadeBlueModifierValue
                    }
                    if ( self.fadeViewController.fadeBlueModifierLabel != nil )
                    {
                        self.fadeViewController.fadeBlueModifierLabel.text = "\(fadeBlueModifierValue)"
                    }
                }
            }
            
            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("error \(httpResponse.statusCode)")
//            }
//
//            if ( error != nil )
//            {
//                print( "Could not get colors. Error: \(error)" )
//            }
//            else
//            {
//                print ( "Got colors: " )
//
//                if let httpResponse = response as? HTTPURLResponse
//                {
//                    print( "status code: \(httpResponse.statusCode)")


//                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8)
//                    NSLog( "GetColors: Response data: \(dataString)" )

                    //let optionalDataString = NSString(data: data!.valueForKey("Optional") as! NSData, encoding:NSUTF8StringEncoding)
                    //NSLog( "Optional: \(optionalDataString)" )

                    //let jsonDataArray = self.nsdataToJSON(data: data!) as? NSDictionary
                    //let jsonDataMap = jsonDataArray?.objectForKey((jsonDataArray?.allKeys[0])!) as? NSDictionary

//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//
//                    guard let jsonDataMap = json as? [String: Any] else
//                    {
//                        print ( "Could not read data" )
//                    }
//
//                    let red = jsonDataMap?.objectForKey( "red" ) as! Int
//                    let green = jsonDataMap?.objectForKey( "green" ) as! Int
//                    let blue = jsonDataMap?.objectForKey( "blue" ) as! Int
//                    let colorStep = jsonDataMap?.objectForKey( "colorStep" ) as! Float
//
//                    let fadeRedModifierValue = jsonDataMap?.objectForKey( "fadeRedModifier" ) as! Float
//                    let fadeGreenModifierValue = jsonDataMap?.objectForKey( "fadeGreenModifier" ) as! Float
//                    let fadeBlueModifierValue = jsonDataMap?.objectForKey( "fadeBlueModifier" ) as! Float
//
//                    let deviceColor = UIColor.init( red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1 )

//                    dispatch_async(dispatch_get_main_queue(), {
//
//
//                        self.view.backgroundColor = deviceColor
//
//                        self.redColorLabel.text = String( red )
//                        self.greenColorLabel.text = String( green )
//                        self.blueColorLabel.text = String( blue )
//
//                        if ( !self.isRedSliderDragged )
//                        {
//                            self.redSlider.value = Float ( (jsonDataMap?.objectForKey( "red" ) as! Float) / 255.0 )
//                        }
//
//                        self.greenSlider.value = Float ( (jsonDataMap?.objectForKey( "green" ) as! Float) / 255.0 )
//                        self.blueSlider.value = Float ( (jsonDataMap?.objectForKey( "blue" ) as! Float) / 255.0 )
//
//                        if ( self.fadeViewController.view != nil )
//                        {
//                            self.fadeViewController.view.backgroundColor = deviceColor
//                        }
//
//                        if ( self.fadeViewController.colorStepSlider != nil )
//                        {
//                            self.fadeViewController.colorStepSlider.value = colorStep
//                        }
//                        if ( self.fadeViewController.colorStepLabel != nil )
//                        {
//                            self.fadeViewController.colorStepLabel.text = "\(colorStep)"
//                        }
//
//                        if ( self.fadeViewController.fadeRedModifierSlider != nil )
//                        {
//                            self.fadeViewController.fadeRedModifierSlider.value = fadeRedModifierValue;
//                        }
//                        if ( self.fadeViewController.fadeRedModifierLabel != nil )
//                        {
//                            self.fadeViewController.fadeRedModifierLabel.text = "\(fadeRedModifierValue)"
//                        }
//                        if ( self.fadeViewController.fadeGreenModifierSlider != nil )
//                        {
//                            self.fadeViewController.fadeGreenModifierSlider.value = fadeGreenModifierValue
//                        }
//                        if ( self.fadeViewController.fadeGreenModifierLabel != nil )
//                        {
//                            self.fadeViewController.fadeGreenModifierLabel.text = "\(fadeGreenModifierValue)"
//                        }
//                        if ( self.fadeViewController.fadeBlueModifierSlider != nil )
//                        {
//                            self.fadeViewController.fadeBlueModifierSlider.value = fadeBlueModifierValue
//                        }
//                        if ( self.fadeViewController.fadeBlueModifierLabel != nil )
//                        {
//                            self.fadeViewController.fadeBlueModifierLabel.text = "\(fadeBlueModifierValue)"
//                        }
//                    })
//                }
//            }
            
        }
        
        NetworkManager.sharedInstance.sendGetRequest3( path: "currentStatus", completionHandler:completionHandler)
    }
    
    
    
//    func nsdataToJSON(data: Data) -> AnyObject?
//    {
//        do
//        {
//            return try JSONSerialization.JSONObjectWithData(data as Data, options: .MutableContainers)
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil
//    }
    
    
    
    
    @IBAction func urlTextFieldFinishedEditting(textField: UITextField)
    {
        NSLog( "New value: " + textField.text! )
        NetworkManager.sharedInstance.ipString = "http://" + textField.text! + "/"
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func redOnButton(sender: UIButton)
    {
        NSLog( "Red On Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "redOn" );
    }
    
    @IBAction func redHalfButton(sender: UIButton)
    {
        NSLog( "Red Half Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "redHalf" );
    }
    
    @IBAction func redOffButton(sender: UIButton)
    {
        NSLog( "Red Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "redOff" );
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider)
    {
        NSLog( "Red Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( path: "redValue/", params: params )
    }
    
    @IBAction func onRedSliderDragStart(sender: UISlider)
    {
        self.isRedSliderDragged = true;
    }
    
    @IBAction func onRedSliderDragEnd(sender: UISlider)
    {
        self.isRedSliderDragged = false;
    }
    
    @IBAction func greenOnButton(sender: UIButton)
    {
        NSLog( "Green On Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "greenOn" );
    }
    
    @IBAction func greenHalfButton(sender: UIButton)
    {
        NSLog( "Green Half Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "greenHalf" );
    }
    
    @IBAction func greenOffButton(sender: UIButton)
    {
        NSLog( "Green Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "greenOff" );
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider)
    {
        NSLog( "Green Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( path: "greenValue/", params: params )
    }
    
    @IBAction func blueOnButton(sender: UIButton)
    {
        NSLog( "Blue On Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "blueOn" );
    }
    
    @IBAction func blueHalfButton(sender: UIButton)
    {
        NSLog( "Blue Half Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "blueHalf" );
    }
    
    @IBAction func blueOffButton(sender: UIButton)
    {
        NSLog( "Blue Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "blueOff" );
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider)
    {
        NSLog( "Blue Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( path: "blueValue/", params: params )
    }
    
    @IBAction func fadeButton(sender: UIButton)
    {
        NSLog( "Fade Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "fade" );
    }
    
    @IBAction func strobeButton(sender: UIButton)
    {
        NSLog( "Strobe Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "strobe" );
    }
    
    @IBAction func allOnButton(sender: UIButton)
    {
        NSLog( "All On Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "allOn" );
    }
    
    @IBAction func allOffButton(sender: UIButton)
    {
        NSLog( "All Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( path: "allOff" );
    }
}

