//
//  CLSubReportDataCell.swift
//  BASCustomReport
//
//  Created by iMac2 on 08/05/19.
//  Copyright © 2019 Badal Shah. All rights reserved.
//

import UIKit

class CLSubReportDataCell: UICollectionViewCell {

    /// All UIRelated Setting -> Headercolor , seperator Color , HeaderSize , SeperatorSize Bla Bla
    var layoutSettings = BASReportLayout()
    var delegate:BASReportDelegate?
      var basReportDatasource: BASReportDatasource?
     var arrIndexPath : [Int] = []
    
    weak var basReportHeaderDatasource: BASReportHeaderDatasource?
      var arrCustomHeaderSectionForColumn : [Int] = []
    
   
    
    
    //Outlets
    @IBOutlet weak var tblReportSummary: SwappingTableView!
    
    
    //Variables
    /// itemIndex is Index of CollectionView -> totalArray -1 Because First(object) is Already implimented Seperarely
    var itemIndex = IndexPath()
    /// SearchDictionary for search Functionality
    var arrReportSummaryDict  : [Dictionary<String, Any>] = []
    /// <String is HeaderName> and <Bool TRUE displayImage , FALSE display Text>
    var arrGHeader = OrderedDictionary<String, Bool>()
    
    /// 0. is Dictionary Keys(Json Webservice Keys) and 1. is Text Allignment(Left , Right , Center) to display Text  2.Custom CellWidth of Column 3. Custom BackGroundColor of Particular cell
    var arrGKeys = [keysAndAllignment]()
    /// .0 is for identify selected Header and .1 get current sorting for that Header(ascending and Descending)
    var validateSelectedLabel = ("","")
    
    var basCustomReport : BASCustomReport?
    
    var isSubCellClickable = true
    

    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        
        print("longPressGestureRecognized")
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tblReportSummary)
        let indexPath = tblReportSummary.indexPathForRow(at: locationInView)
        
        
        print("UILongPressGestureRecognizer")
        switch(gestureRecognizer.state)
        {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = tblReportSummary?.indexPathForRow(at: gestureRecognizer.location(in: tblReportSummary)) else {
                break
            }
            tblReportSummary?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            tblReportSummary?.updateInteractiveMovementTargetPosition(gestureRecognizer.location(in: gestureRecognizer.view!))
        case UIGestureRecognizerState.ended:
            tblReportSummary?.endInteractiveMovement()
        default:
            tblReportSummary?.cancelInteractiveMovement()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
        
    }
    
    //Register Nibs
    func registerCells() {
        tblReportSummary.register(UINib(nibName: "tblCellHeader", bundle: BASREPORT_BUNDLE), forCellReuseIdentifier: "tblCellHeader")
        tblReportSummary.register(UINib(nibName: "tblReportCell", bundle: BASREPORT_BUNDLE), forCellReuseIdentifier: "tblReportCell")
        let longPress = UILongPressGestureRecognizer (target: self, action:#selector(self.longPressGestureRecognized(_:)))
        tblReportSummary.addGestureRecognizer(longPress)
//        tblReportSummary.isEditing = true
//        tblReportSummary.isUserInteractionEnabled = true
//        tblReportSummary.allowsSelection = true
    }
    
    func registerCellWithIdentifier(arrCustomCell:[BASReportCustomCell]) {
        for customCell in arrCustomCell {
            self.tblReportSummary.register(customCell.0, forCellReuseIdentifier: customCell.1)
        }
    }

}

extension CLSubReportDataCell : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let customHeaderDataSource = basReportHeaderDatasource {
            if arrCustomHeaderSectionForColumn.contains(itemIndex.item + 1){
                return customHeaderDataSource.basReport(tableView, viewForHeaderInSection: section, column: itemIndex.item + 1)
            }
        }
        let cell:tblCellHeader = tableView.dequeueReusableCell(withClass: tblCellHeader.self)
        cell.validateSelectedLabel = self.validateSelectedLabel
        
        cell.btnPlaceHolder.addTarget(BASCustomReport(), action: #selector(BASCustomReport().btnSortingTapped(_:)), for: .touchUpInside)
        
        if arrGHeader.count > 0 {
            cell.configureSecondaryHeaderCell(headerTitle: Array(arrGHeader.keys)[itemIndex.item + 1])
            cell.btnPlaceHolder.accessibilityHint = cell.lblHeaderName.text
        }
        cell.layoutSecondaryHeader(layoutSetting: self.layoutSettings)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.layoutSettings.HEADER_SIZE
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.layoutSettings.CELL_SIZE
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReportSummaryDict.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let customDataSource = basReportDatasource {
            if arrIndexPath.contains(itemIndex.item+1){
                return customDataSource.basReport(tableView, cellForRowAt: indexPath, column: itemIndex.item+1)               
            }
        }
        let cell:tblReportCell = tableView.dequeueReusableCell(withClass: tblReportCell.self)
        cell.layoutSecondaryCell(layoutSetting: self.layoutSettings)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.clear
        cell.lblReport.accessibilityIdentifier = "detail_label"
        
        let key = Array(arrGHeader.keys)[itemIndex.item + 1]
        if arrGHeader[key] == true {
            cell.lblReport.text = ""
            cell.imgReport.image = UIImage(named: (self.arrReportSummaryDict[indexPath.row][arrGKeys[itemIndex.item + 1].0] as! String))
        } else {
            cell.imgReport.image = nil //UIImage(named: "")
            if let text = self.arrReportSummaryDict[indexPath.row][arrGKeys[itemIndex.item + 1].0] as? Int {
                cell.lblReport.text = text.toString()
            }
            if let text = self.arrReportSummaryDict[indexPath.row][arrGKeys[itemIndex.item + 1].0] as? Float {
                cell.lblReport.text = text.toString()
            }
            if let text = self.arrReportSummaryDict[indexPath.row][arrGKeys[itemIndex.item + 1].0] as? Double {
                cell.lblReport.text = text.toString()
            }
            if let text = self.arrReportSummaryDict[indexPath.row][arrGKeys[itemIndex.item + 1].0] as? String {
                cell.lblReport.text = text
                


//                let colors = ["yellow", "green", "pink"] // stored as String
//                UIColor.fromString(name: colors.randomElement())

                let enumColors: [UIColor.ColorEnum] = [.yellow, .green, .pink] // stored as enum
                cell.backgroundColor = !(text.isEmpty) ? enumColors.randomElement().toColor() : .white
            }
            
            cell.lblReport.textAlignment = arrGKeys[itemIndex.item + 1].1
            if arrGKeys[itemIndex.item + 1].3 != nil {
                if !isSubCellClickable {
                    cell.contentView.backgroundColor = arrGKeys[itemIndex.item + 1].3
                } else {
                    cell.lblReport.textColor = arrGKeys[itemIndex.item + 1].3
                }
            }
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.basCustomReport?.needToScroll(scrollView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        guard let subDataDelegate = self.delegate else {return}
        subDataDelegate.didSelectCellAt?(indexPath: indexPath, tableHint: tableView.accessibilityHint ?? "", basReport: self.basCustomReport)
    }
    
    
}

