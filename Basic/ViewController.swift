//
//  ViewController.swift
//  Basic
//
//  Created by Qingyang Su on 3/24/18.
//  Copyright © 2018 Qingyang Su. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, BluetoothListDelegate, CBPeripheralDelegate {
    
    @IBOutlet var setTime: UILabel!
    var receiveTime = String()
    var mainPeripheral: CBPeripheral?
    @IBOutlet weak var goGraphButton: UIButton!
    @IBOutlet weak var timeSettingButton: UIButton!
    @IBOutlet weak var bluetoothPairButton: UIButton!
    
    @IBAction func unwindToSetTime(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TimerSettingViewController, let interval = sourceViewController.hrDisplay.text {
            receiveTime = interval
        }
    }
    @IBAction func goGraph(_ sender: Any) {
        let myVC = Graph(nibName: "Graph", bundle: Bundle.main)
        myVC.peripheralPassed = mainPeripheral
        myVC.stringtime = receiveTime
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func bluetoothListDidSelectPeripheral(peripheral: CBPeripheral) {
        print("inside viewController, got peripheral ", peripheral)
        mainPeripheral = peripheral
        
        let characteristic = mainPeripheral!.services!.last!.characteristics!.last!
        let data = "Hello World".data(using: String.Encoding.utf8)!
        
        //[peripheral writeValue:data forCharacteristic:testCharacteristic type:CBCharacteristicWriteWithResponse];
        // ios core-bluetooth
        
        mainPeripheral?.writeValue(data, for: characteristic, type: .withoutResponse)
        
        // get callbacks when data is sent from the device to the phone
        mainPeripheral?.delegate = self
        mainPeripheral?.setNotifyValue(true, for: characteristic)
        goGraphButton.isEnabled = true
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("updated value for characteristic: ", String(data: characteristic.value!, encoding: String.Encoding.utf8)!)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goGraphButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
        
        bluetoothPairButton.addTarget(self, action: #selector(bluetoothPairButtonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func bluetoothPairButtonPressed(sender: Any) {
        print("pressed");
        
        let tableViewController = TableViewController(style: .plain);
        tableViewController.bluetoothListDelegate = self
        //let navController = UINavigationController(rootViewController: tableViewController)
        self.navigationController?.pushViewController(tableViewController, animated: true)
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

