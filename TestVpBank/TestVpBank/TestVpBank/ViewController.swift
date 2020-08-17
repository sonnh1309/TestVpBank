//
//  ViewController.swift
//  TestVpBank
//
//  Created by sonnh on 8/17/20.
//  Copyright © 2020 FastGo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var basReport: BASCustomReport!
    var sampleData = [SampleData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Test VpBank"
        self.basReport.delegate = self
        initialSetup()
    }
    
    func initialSetup() {
        var HeaderDict = OrderedDictionary<String, Bool>()
        HeaderDict[""] = false ;
        HeaderDict["Nguyen A"] = false;
        HeaderDict["Nguyen B"] = false;
        HeaderDict["Nguyen C"] = false;
        HeaderDict["Nguyen D"] = false;
        HeaderDict["Nguyen E"] = false;
        HeaderDict["Nguyen F"] = false;
        HeaderDict["Nguyen G"] = false;
        HeaderDict["Nguyen H"] = false;
        HeaderDict["Nguyen I"] = false;
        HeaderDict["Nguyen K"] = false;
        self.basReport.arrGHeader = HeaderDict
        self.basReport.layoutSettings.setAllHeaderFont(font: UIFont(name: "Times New Roman", size: 17.0)!)
        self.basReport.layoutSettings.setAllDataFont(font: UIFont(name: "Times New Roman", size: 14.0)!)
        
        setData()
    }
    
    func setData() {
        if let path = Bundle.main.path(forResource: "Example", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let tempData  = try JSONDecoder().decode(RootClass.self, from: data )
                self.sampleData = tempData.data!
                self.basReport.arrGKeys = [("timespan",.left,nil , nil) , ("nguyen_1",.center,nil , nil), ("nguyen_2",.center,nil , nil), ("nguyen_3",.center,nil , nil), ("nguyen_4",.center,nil , nil), ("nguyen_5",.center,nil , nil), ("nguyen_6",.center,nil , nil), ("nguyen_7",.center,nil , nil), ("nguyen_8",.center,nil , nil), ("nguyen_9",.center,nil , nil), ("nguyen_10",.center,nil , nil)]
                if basReport.arrGHeader.count == basReport.arrGKeys.count{
                    self.basReport.arrReportSummaryDict = arryToDict(array: self.sampleData)
                }
            } catch {
                // handle error
            }
        }
        
    }

}

extension ViewController : BASReportDelegate {

}
