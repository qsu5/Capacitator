//
//  TimerSettingViewController.swift
//  Basic
//
//  Created by Qingyang Su on 3/25/18.
//  Copyright © 2018 Qingyang Su. All rights reserved.
//

import UIKit
import os.log

class TimerSettingViewController: UIViewController {
    @IBOutlet weak var hrDisplay: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timer(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm:ss"
        let date: Date? = sender.date
        
        hrDisplay.text = dateFormatter.string(from: date!)
        print("in timer action")
        print(sender.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let dateFormatter = DateFormatter()
//        timer(UIDatePicker())
        
//        dateFormatter.dateFormat = "HH:mm:ss"
//        let date: Date = dateFormatter.date(from: "00:01:00")!
//
//        hrDisplay.text = dateFormatter.string(from: date)
//        print("in view load")
//        print(date)


        
        // Do any additional setup after loading the view.
    }



    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
         //Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
//        let newTimer = segue.destination as! ViewController
//        newTimer.receiveTime = hrDisplay.text!
        print("I came here")
        
    }

}


//extension TimerSettingViewController: UIPickerViewDataSource, UIPickerViewDelegate{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        <#code#>
//    }
//}

