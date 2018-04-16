//
//  Graph.swift
//  Basic
//
//  Created by Qingyang Su on 4/14/18.
//  Copyright © 2018 Qingyang Su. All rights reserved.
//

import UIKit
import CoreBluetooth
import ScrollableGraphView



class Graph: UIViewController, CBPeripheralDelegate, ScrollableGraphViewDataSource{

    @IBOutlet weak var currentVal: UILabel!
    @IBOutlet weak var graphView: UIView!
    var linePlotData =  [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]
    //lazy var linePlotData: [Double] = self.generateRandomData(29, max: 50, shouldIncludeOutliers: true)
    var peripheralPassed: CBPeripheral?
    var plotview: ScrollableGraphView!
    var stringtime = ""
    
//    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
//        var data = [Double]()
//        for _ in 0 ..< numberOfItems {
//            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
//
//            if(shouldIncludeOutliers) {
//                if(arc4random() % 100 < 10) {
//                    randomNumber *= 3
//                }
//            }
//
//            data.append(randomNumber)
//        }
//        return data
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentVal.text = "I'am a test label..."
        
        peripheralPassed?.delegate = self
        let frame = graphView.frame
        plotview = ScrollableGraphView(frame: frame, dataSource: self)
        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        let referenceLines = ReferenceLines()

        plotview.addPlot(plot: linePlot)
        plotview.addReferenceLines(referenceLines: referenceLines)
        plotview.rangeMax = 255
        
        self.graphView.addSubview(plotview)
        // Do any additional setup after loading the view.
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "line":
            return Double(linePlotData[pointIndex])
        default:
            return 0
        }
    }

    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex)"
    }

    func numberOfPoints() -> Int {
        return linePlotData.count
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let comeData = String(data: characteristic.value!, encoding: String.Encoding.utf8)!
        print("new data point: ", comeData)
        linePlotData.insert(Double(comeData)!, at: 0)
        linePlotData.removeLast()
        plotview.reload()
        // call graph thing here
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
