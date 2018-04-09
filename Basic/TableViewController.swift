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

class TableViewController: UITableViewController,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager:CBCentralManager!
    var peripherals:[CBPeripheral]!
    var peripheral:CBPeripheral!
    var parentView:ViewController? = nil
    @IBOutlet weak var SaveButton: UIBarButtonItem!

    @IBAction func CancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
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
        SaveButton.isEnabled = false
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
        if (!peripherals.contains(peripheral)){
            peripherals.append(peripheral)
        }
        self.tableView.reloadData()
        print("discover a device")
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // pass reference to connected peripheral to parentview
        SaveButton.isEnabled = true
        print("Connected to "+peripheral.name!)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        //Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === SaveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
    }
 

}
