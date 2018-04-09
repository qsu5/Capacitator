//
//  ViewController.swift
//  Basic
//
//  Created by Qingyang Su on 3/24/18.
//  Copyright © 2018 Qingyang Su. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {


    @IBOutlet var setTime: UILabel!
    var receiveTime = String()
    var mainPeripheral: CBPeripheral!
    @IBOutlet weak var timeSettingButton: UIButton!
    @IBOutlet weak var bluetoothPairButton: UIButton!
    
    @IBAction func unwindToSetTime(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TimerSettingViewController, let interval = sourceViewController.hrDisplay.text {
            receiveTime = interval
        }
    }
    @IBAction func unwindToPairBluetooth(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? TableViewController, let peripheral =
            sourceViewController.peripheral{
            mainPeripheral = peripheral
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func timeSetting(_ sender: Any) {
        
    }
    
    @IBAction func findBluetooth(_ sender: Any) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        print("i am printing")
        print (receiveTime)
        super.viewDidAppear(animated)
        setTime.text = receiveTime
    }

}

