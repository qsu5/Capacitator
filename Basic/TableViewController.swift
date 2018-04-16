//
//  TableViewController.swift
//  Basic
//
//  Created by Qingyang Su on 4/1/18.
//  Copyright © 2018 Qingyang Su. All rights reserved.
//

import UIKit
import CoreBluetooth
import os.log

@objc protocol BluetoothListDelegate {
    func bluetoothListDidSelectPeripheral(peripheral: CBPeripheral);
}

class TableViewController: UITableViewController,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @IBOutlet var bluetoothListDelegate: BluetoothListDelegate!
    
    var manager:CBCentralManager!
    var peripherals:[CBPeripheral]!
    var peripheral:CBPeripheral!
    var parentView:ViewController? = nil
    let service_uuid = CBUUID(string: "ffe0")
    //let service_uuid = CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb")
    let char_uuid = CBUUID(string: "0000ffe1-0000-1000-8000-00805f9b34fb")
    
    var saveButton: UIBarButtonItem!
    
    //    let BEAN_NAME = "Robu"
//    let BEAN_SCRATCH_UUID =
//        CBUUID()
//    let BEAN_SERVICE_UUID =
//        CBUUID()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Searching for device.")
        } else {
            print("Bluetooth not available.")
        }
    }
    
//    private func centralManager(
//        central: CBCentralManager,
//        didDiscoverPeripheral peripheral: CBPeripheral,
//        advertisementData: [String : AnyObject],
//        RSSI: NSNumber) {
//        let device = (advertisementData as NSDictionary)
//            .object(forKey: CBAdvertisementDataLocalNameKey)
//            as? NSString
//
//        if device?.contains(BEAN_NAME) == true {
//            self.manager.stopScan()
//
//            self.peripheral = peripheral
//            self.peripheral.delegate = self
//
//            manager.connect(peripheral, options: nil)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CBCentralManager(delegate: self, queue: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // init peripherals
        peripherals = [CBPeripheral]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peripherals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell";
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier);
        }
        
        let peripheral = peripherals[indexPath.row]
        if let name = peripheral.name {
            cell!.textLabel?.text = name
        }
        else {
            cell!.textLabel?.text = "<no name>";
        }
        
        // Configure the cell...
        cell!.detailTextLabel?.text = String(format: "%p", peripheral);
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.manager.stopScan()
        self.peripheral = peripherals[indexPath.row]
        self.peripheral.delegate = self
        manager?.connect(peripheral, options: nil)
        print("select a device")
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!peripherals.contains(peripheral) ){
            peripherals.append(peripheral)
        }
        self.tableView.reloadData()
        print("discover a device -- advertisementData", advertisementData)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.discoverServices(nil)
        
        if let theName = peripheral.name {
            print("Connected to " + theName)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if peripheral.services != nil{
            print ("there are services")
            for service in peripheral.services!{
                peripheral.discoverCharacteristics(nil, for: service)
                
                //let thisService = service as CBService
                print(service.uuid)
            }
        }
        else{
            print("no services")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("discovered characteristics");
        
        for char in service.characteristics! {
            print(char.uuid)
            
            if let del = bluetoothListDelegate {
                del.bluetoothListDidSelectPeripheral(peripheral: peripheral)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
