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
}
