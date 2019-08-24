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
    
    //
    @IBOutlet weak var calendar: JTACMonthView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingLabelView: UIView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var saveLogButton: UIButton!
    @IBOutlet weak var editActionsButton: UIButton!
    
    //MARK: - Propertiess
    
    var selectedDate: Date = Date()
    var selectedCell: DateDayCollectionViewCell?
    var selectedCellState: CellState?
    var currentMonth: String?
    var currentYear: String?
    var rating: Int = 5
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.showsVerticalScrollIndicator = false
//        happinessSlider.isEnabled = false
//        saveLogButton.isEnabled = false
//        editActionsButton.isEnabled = false
        disableAllInteractables()
        
        saveLogButton.layer.cornerRadius = saveLogButton.frame.size.height / 2.0
        saveLogButton.backgroundColor = RatingColors.getColorFoInt(number: rating)
//        editActionsButton.layer.borderWidth = 4
//        editActionsButton.layer.borderColor = happinessColors.getColorFoInt(number: 5).cgColor
        editActionsButton.layer.cornerRadius = editActionsButton.frame.size.height / 2.0
        ratingLabelView.layer.cornerRadius = ratingLabelView.frame.size.height / 2.0
        editActionsButton.backgroundColor = RatingColors.getColorFoInt(number: rating)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions

    @IBAction func ratingSliderValueChanged(_ sender: UISlider) {
        rating = Int(round(sender.value))
        sender.value = Float(rating)
        updateUIForRating()
        changeColorsForRating()
    }
    
    @IBAction func saveDateButtonTapped(_ sender: Any) {
        if selectedCell != nil{
            let feedback = UINotificationFeedbackGenerator()
            feedback.notificationOccurred(.success)
            
            calendar.deselect(dates: [selectedDate])
            if let log = LogController.shared.getLogForDate(date: selectedDate) {
                LogController.shared.updateLog(log: log, selectedActivities: [], rating: rating)
            } else {
                LogController.shared.createLog(date: selectedDate, rating: rating)
            }
            calendar.reloadData()
            disableAllInteractables()
            rating = 5
        }
    }
    
    // MARK: - Custom Functions
    
    func updateUIForRating() {
        ratingLabel.text = String(rating)
    }
    
    func changeColorsForRating() {
        ratingSlider.minimumTrackTintColor = RatingColors.getColorFoInt(number: rating)
        ratingSlider.thumbTintColor = RatingColors.getColorFoInt(number: rating)
        editActionsButton.backgroundColor = RatingColors.getColorFoInt(number: rating)
        saveLogButton.backgroundColor = RatingColors.getColorFoInt(number: rating)
        ratingLabelView.layer.backgroundColor = RatingColors.getColorFoInt(number: rating).cgColor
    }
    
    func enableAllInteractables() {
        ratingSlider.isEnabled = true
        saveLogButton.isHidden = false
        editActionsButton.isHidden = false
        ratingLabelView.isHidden = false
    }
    func disableAllInteractables() {
        ratingSlider.isEnabled = false
        saveLogButton.isHidden = true
        editActionsButton.isHidden = true
        ratingLabelView.isHidden = true
    }
    
    
    // MARK: - Calendar Functions
    
    func configureCell(view: JTACDayCell?, cellState: CellState, rating: Int? = nil) {
        guard let cell = view as? DateDayCollectionViewCell  else { return }
        handleCellTextColor(cell: cell, cellState: cellState)
        cell.setupCellBeforeDisplay(cellState: cellState, rating: rating)
    }
    
    func handleCellTextColor(cell: DateDayCollectionViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
                        cell.isHidden = false
        } else {
//            cell.dateLabel.textColor = UIColor.lightGray
                        cell.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMMM"
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeaderForCalendar
        header.monthTitle.text = formatter.string(from: range.start)
        formatter.dateFormat = "yyyy"
        header.yearLabel.text = formatter.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 55)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let impactGenerator = UISelectionFeedbackGenerator()
        impactGenerator.selectionChanged()
        ratingSlider.isEnabled = true
        selectedDate = cellState.date
        guard let cell = cell as? DateDayCollectionViewCell else {return}
        selectedCell = cell
        if let log = LogController.shared.getLogForDate(date: cellState.date) {
            rating = Int(log.rating)
            configureCell(view: cell, cellState: cellState, rating: Int(log.rating))
            ratingLabelView.layer.backgroundColor = RatingColors.getColorFoInt(number: Int(log.rating)).cgColor
            ratingSlider.minimumTrackTintColor = RatingColors.getColorFoInt(number: Int(log.rating))
            ratingSlider.thumbTintColor = RatingColors.getColorFoInt(number: Int(log.rating))
            ratingSlider.value = Float(log.rating)
            ratingLabel.text = "\(Int(log.rating))"
        } else {
            configureCell(view: cell, cellState: cellState)
            ratingLabelView.layer.backgroundColor = RatingColors.getColorFoInt(number: 5).cgColor
            ratingSlider.minimumTrackTintColor = RatingColors.getColorFoInt(number: 5)
            ratingSlider.thumbTintColor = RatingColors.getColorFoInt(number: 5)
            ratingSlider.value = 5
            ratingLabel.text = "\(rating)"
        }
//        ratingLabelView.isHidden = false
//        happinessSlider.isEnabled = true
//        saveLogButton.isEnabled = true
//        editActionsButton.isEnabled = true
        enableAllInteractables()
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if let log = LogController.shared.getLogForDate(date: cellState.date) {
            configureCell(view: cell, cellState: cellState, rating: Int(log.rating))
        } else {
            configureCell(view: cell, cellState: cellState, rating: -1)
        }
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
        let log = LogController.shared.getLogForDate(date: cellState.date)
        if selectedDate == cellState.date {
            selectedCell = cell as? DateDayCollectionViewCell
            if let log = log {
                configureCell(view: cell, cellState: cellState, rating: Int(log.rating))
            } else {
                configureCell(view: cell, cellState: cellState)
            }
        } else {
            if let log = log {
                configureCell(view: cell, cellState: cellState, rating: Int(log.rating))
            } else {
                configureCell(view: cell, cellState: cellState)
            }
        }
    }
}
