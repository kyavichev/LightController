//
//  FadeTabViewController.swift
//  LightController
//
//  Created by Konstantin Yavichev on 8/7/16.
//  Copyright © 2016 BumperHeads. All rights reserved.
//

import UIKit

class FadeTabViewController: UIViewController
{
    @IBOutlet var redRangeLabel: UILabel!
    @IBOutlet var redRangeMinSlider: UISlider!
    @IBOutlet var redRangeMaxSlider: UISlider!
    
    @IBOutlet var greenRangeLabel: UILabel!
    @IBOutlet var greenRangeMinSlider: UISlider!
    @IBOutlet var greenRangeMaxSlider: UISlider!
    
    @IBOutlet var blueRangeLabel: UILabel!
    @IBOutlet var blueRangeMinSlider: UISlider!
    @IBOutlet var blueRangeMaxSlider: UISlider!
    
    
    @IBOutlet weak var colorStepSlider : UISlider!
    @IBOutlet weak var colorStepLabel : UILabel!
    
    @IBOutlet weak var fadeRedModifierSlider : UISlider!
    @IBOutlet weak var fadeRedModifierLabel: UILabel!
    
    @IBOutlet weak var fadeGreenModifierSlider : UISlider!
    @IBOutlet weak var fadeGreenModifierLabel: UILabel!
    
    @IBOutlet weak var fadeBlueModifierSlider : UISlider!
    @IBOutlet weak var fadeBlueModifierLabel: UILabel!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    @IBAction func redRangeSliderValueChanged(sender: UISlider)
    {
        NSLog( "Red Range Slider Value Changed!" );
        
        let redMin = Int(255 * self.redRangeMinSlider.value)
        let redMax = Int(255 * self.redRangeMaxSlider.value)
        let text = "Red [\(redMin) - \(redMax)]" as String
        self.redRangeLabel.text = text
        
        let params = ["redMin":"\(self.redRangeMinSlider.value)", "redMax":"\(self.redRangeMaxSlider.value)"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "colorLimit/", params: params )
    }
    
    
    @IBAction func greenRangeSliderValueChanged(sender: UISlider)
    {
        NSLog( "Green Range Slider Value Changed!" );
        
        let greenMin = Int(255 * self.greenRangeMinSlider.value)
        let greenMax = Int(255 * self.greenRangeMaxSlider.value)
        let text = "Green [\(greenMin) - \(greenMax)]" as String
        self.greenRangeLabel.text = text
        
        let params = ["greenMin":"\(self.greenRangeMinSlider.value)", "greenMax":"\(self.greenRangeMaxSlider.value)"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "colorLimit/", params: params )
    }
    
    
    @IBAction func blueRangeSliderValueChanged(sender: UISlider)
    {
        NSLog( "Blue Range Slider Value Changed!" );
        
        let blueMin = Int(255 * self.blueRangeMinSlider.value)
        let blueMax = Int(255 * self.blueRangeMaxSlider.value)
        let text = "Blue [\(blueMin) - \(blueMax)]" as String
        self.blueRangeLabel.text = text
        
        let params = ["blueMin":"\(self.blueRangeMinSlider.value)", "blueMax":"\(self.blueRangeMaxSlider.value)"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "colorLimit/", params: params )
    }
    
    
    @IBAction func colorStepSliderValueChanged(sender: UISlider)
    {
        NSLog( "Color Step Slider Value Change!" );
        
        let params = ["value":"\(sender.value)", "test":"abcd"] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "colorStep/", params: params )
        
        if ( self.colorStepLabel != nil)
        {
            self.colorStepLabel.text = "\(round(10000*sender.value)/10000)";
        }
    }
    
    
    @IBAction func fadeModifierSliderValueChanged(sender: UISlider)
    {
        NSLog( "Fade Modifier Slider Value Change!" );
        
        let params = ["fadeRedModifier":"\(self.fadeRedModifierSlider.value)", "fadeGreenModifier":"\(self.fadeGreenModifierSlider.value)", "fadeBlueModifier": "\(self.fadeBlueModifierSlider.value)" ] as Dictionary<String, String>
        NetworkManager.sharedInstance.sendPostRequest( "setFadeModifiers/", params: params )
        
        self.fadeRedModifierLabel.text = "\(round(10000*self.fadeRedModifierSlider.value)/10000)"
        self.fadeGreenModifierLabel.text = "\(round(10000*self.fadeGreenModifierSlider.value)/10000)"
        self.fadeBlueModifierLabel.text = "\(round(10000*self.fadeBlueModifierSlider.value)/10000)"
    }
}
