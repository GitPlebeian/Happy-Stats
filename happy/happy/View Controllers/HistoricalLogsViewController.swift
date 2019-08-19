//
//  HistoricalLogsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/10/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit
import JTAppleCalendar

class HistoricalLogsViewController: UIViewController{
    
    // MARK: - Outlets
    
//    @IBOutlet weak var calendar: JTACMonthView!
    @IBOutlet weak var calendar: JTACMonthView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.showsVerticalScrollIndicator = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateDayCollectionViewCell  else { return }
        //        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        cell.setupCellBeforeDisplay(cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateDayCollectionViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
            //            cell.isHidden = false
        } else {
            cell.dateLabel.textColor = UIColor.lightGray
            //            cell.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMMM yyyy"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeaderForCalendar
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 60)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showLog" {
//            guard let index = logsTableView.indexPathForSelectedRow, let destinationViewController = segue.destination as? LogDetailViewController else {return}
//            let log = LogController.shared.logs[index.row]
//            destinationViewController.log = log
//        }
//    }
}

extension HistoricalLogsViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2019 06 01")!
        let endDate = Date()
        //        return ConfigurationParameters(startDate: startDate, endDate: endDate)
        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar(identifier: Calendar.current.identifier), generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, hasStrictBoundaries: false)
    }
}

extension HistoricalLogsViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateDayCollectionViewCell
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
}
