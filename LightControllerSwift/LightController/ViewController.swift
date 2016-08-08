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
    
    @IBOutlet weak var fadeRedModifierSlider : UISlider!
    @IBOutlet weak var fadeGreenModifierSlider : UISlider!
    @IBOutlet weak var fadeBlueModifierSlider : UISlider!
    
    @IBOutlet weak var fadeRedModifierLabel: UILabel!
    @IBOutlet weak var fadeGreenModifierLabel: UILabel!
    @IBOutlet weak var fadeBlueModifierLabel: UILabel!
    
    @IBOutlet weak var colorStepSlider : UISlider!
    @IBOutlet weak var colorStepLabel : UILabel!
    
    
    var isRedSliderDragged : Bool!
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.urlTextField.delegate = self;
        
        self.isRedSliderDragged = false;
        
        NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(ViewController.checkHeartBeat), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.getStatus), userInfo: nil, repeats: true)
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
        
        NetworkManager.sharedInstance.sendGetRequest3( "heartBeat", completionHandler:completionHandler)
    }
    
    
    func getStatus ()
    {
        NSLog( "Getting colors" );
        
        let completionHandler:(NSData?, NSURLResponse?, NSError?) -> Void = { (data, response, error:NSError?) in
            
            if ( error != nil )
            {
                print( "Could not get colors. Error: \(error)" )
                
            }
            else
            {
                NSLog ( "Got colors: " )
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    NSLog( "status code: \(httpResponse.statusCode)")
                    
                    
                    let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    NSLog( "GetColors: Response data: \(dataString)" )
                    
                    //let optionalDataString = NSString(data: data!.valueForKey("Optional") as! NSData, encoding:NSUTF8StringEncoding)
                    //NSLog( "Optional: \(optionalDataString)" )
                    
                    let jsonDataArray = self.nsdataToJSON(data!) as? NSDictionary
                    let jsonDataMap = jsonDataArray?.objectForKey((jsonDataArray?.allKeys[0])!) as? NSDictionary
                    let red = String( jsonDataMap?.objectForKey( "red" ) as! Int )
                    let green = String ( jsonDataMap?.objectForKey( "green" ) as! Int )
                    let blue = String( jsonDataMap?.objectForKey( "blue" ) as! Int )
                    let colorStep = jsonDataMap?.objectForKey( "colorStep" ) as! Float
                    
                    let fadeRedModifierValue = jsonDataMap?.objectForKey( "fadeRedModifier" ) as! Float
                    let fadeGreenModifierValue = jsonDataMap?.objectForKey( "fadeGreenModifier" ) as! Float
                    let fadeBlueModifierValue = jsonDataMap?.objectForKey( "fadeBlueModifier" ) as! Float
                    
                
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.redColorLabel.text = red;
                        self.greenColorLabel.text = green;
                        self.blueColorLabel.text = blue;
                        
                        if ( !self.isRedSliderDragged )
                        {
                            self.redSlider.value = Float ( (jsonDataMap?.objectForKey( "red" ) as! Float) / 255.0 )
                        }
                        
                        self.greenSlider.value = Float ( (jsonDataMap?.objectForKey( "green" ) as! Float) / 255.0 )
                        self.blueSlider.value = Float ( (jsonDataMap?.objectForKey( "blue" ) as! Float) / 255.0 )
                        
                        self.colorStepSlider.value = colorStep;
                        self.colorStepLabel.text = "\(colorStep)"
                        
                        self.fadeRedModifierSlider.value = fadeRedModifierValue;
                        self.fadeRedModifierLabel.text = "\(fadeRedModifierValue)"
                        self.fadeGreenModifierSlider.value = fadeGreenModifierValue
                        self.fadeGreenModifierLabel.text = "\(fadeGreenModifierValue)"
                        self.fadeBlueModifierSlider.value = fadeBlueModifierValue
                        self.fadeBlueModifierLabel.text = "\(fadeBlueModifierValue)"
                    })
                }
            }
                
        }
        
        NetworkManager.sharedInstance.sendGetRequest3( "currentStatus", completionHandler:completionHandler)
    }
    
    
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    
    
    
    @IBAction func urlTextFieldFinishedEditting(textField: UITextField)
    {
        NSLog( "New value: " + textField.text! )
        NetworkManager.sharedInstance.ipString = "http://" + textField.text! + "/"
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func redOnButton(sender: UIButton)
    {
        NSLog( "Red On Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "redOn" );
    }
    
    @IBAction func redHalfButton(sender: UIButton)
    {
        NSLog( "Red Half Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "redHalf" );
    }
    
    @IBAction func redOffButton(sender: UIButton)
    {
        NSLog( "Red Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "redOff" );
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider)
    {
        NSLog( "Red Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "redValue/", params: params )
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
        NetworkManager.sharedInstance.sendGetRequest2( "greenOn" );
    }
    
    @IBAction func greenHalfButton(sender: UIButton)
    {
        NSLog( "Green Half Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "greenHalf" );
    }
    
    @IBAction func greenOffButton(sender: UIButton)
    {
        NSLog( "Green Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "greenOff" );
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider)
    {
        NSLog( "Green Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "greenValue/", params: params )
    }
    
    @IBAction func blueOnButton(sender: UIButton)
    {
        NSLog( "Blue On Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "blueOn" );
    }
    
    @IBAction func blueHalfButton(sender: UIButton)
    {
        NSLog( "Blue Half Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "blueHalf" );
    }
    
    @IBAction func blueOffButton(sender: UIButton)
    {
        NSLog( "Blue Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "blueOff" );
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider)
    {
        NSLog( "Blue Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "blueValue/", params: params )
    }
    
    @IBAction func fadeButton(sender: UIButton)
    {
        NSLog( "Fade Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "fade" );
    }
    
    @IBAction func fadeModifierSliderValueChanged(sender: UISlider)
    {
        NSLog( "Fade Red Modifier Slider Value Change!" );
        let params = ["fadeRedModifier":"\(self.fadeRedModifierSlider.value)", "fadeGreenModifier":"\(self.fadeGreenModifierSlider.value)", "fadeBlueModifier": "\(self.fadeBlueModifierSlider.value)" ] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "setFadeModifiers/", params: params )
        
        self.fadeRedModifierLabel.text = "\(self.fadeRedModifierSlider.value)"
        self.fadeGreenModifierLabel.text = "\(self.fadeGreenModifierSlider.value)"
        self.fadeBlueModifierLabel.text = "\(self.fadeBlueModifierSlider.value)"
    }
    
    @IBAction func strobeButton(sender: UIButton)
    {
        NSLog( "Strobe Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "strobe" );
    }
    
    @IBAction func allOnButton(sender: UIButton)
    {
        NSLog( "All On Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "allOn" );
    }
    
    @IBAction func allOffButton(sender: UIButton)
    {
        NSLog( "All Off Button!" );
        NetworkManager.sharedInstance.sendGetRequest2( "allOff" );
    }
    
    
    @IBAction func colorStepSliderValueChanged(sender: UISlider)
    {
        NSLog( "Color Step Slider Value Change!" );
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "colorStep/", params: params )
        
        if ( self.colorStepLabel != nil)
        {
            self.colorStepLabel.text = "\(Double(round(1000*sender.value)/1000))";
        }
    }
}

