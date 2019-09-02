//
//  HistoricalLogsViewController.swift
//  happy
//
//  Created by Jackson Tubbs on 8/10/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit

class HistoricalLogsViewController: UIViewController{
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var ratingEditStackView: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingLabelView: UIView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var saveLogButton: UIButton!
    @IBOutlet weak var actionsButton: UIButton!
    
    // MARK: - Properties
    
    var rating = 5
    
    // Used to only scroll to the bottom when the view firsts loads.
    var scrolledToBottom = false
    
    var selectedDate: Date?
    var currentLog: Log?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.isPagingEnabled = true
        calendarCollectionView.showsVerticalScrollIndicator = false
        
        ratingEditStackView.isUserInteractionEnabled = false
        ratingEditStackView.alpha = 0.5
        ratingLabel.text = "Select Date"
        ratingLabelView.layer.cornerRadius = ratingLabel.frame.height / 2
        ratingSlider.thumbTintColor = .black
        ratingSlider.minimumTrackTintColor = .black
        saveLogButton.layer.cornerRadius = saveLogButton.frame.height / 2
        actionsButton.layer.cornerRadius = actionsButton.frame.height / 2
        
        // Sets the month label and year label equal to todays date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        monthLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy"
        yearLabel.text = dateFormatter.string(from: date)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Used inside of didappear because the collectionview cannot be modified in the scrolling way unless it has appeared
        if !scrolledToBottom {
            scrollToBottom()
        }
    }
    
    // MARK: - Actions {
    
    @IBAction func ratingSliderValueChanged(_ sender: UISlider) {
        rating = Int(round(sender.value))
        ratingSlider.value = Float(rating)
        updateViewsForRating()
    }
    
    
    // MARK: - Custom Funcitons
    
    // Used because the most current date is at the bottom of the collections view. I set it to the bottom of the collection view because I think it is more intuitive to the user. Easier user experience
    func scrollToBottom() {
        scrolledToBottom = true
        let contentSize = calendarCollectionView.contentSize
        let targetContentOffset = CGPoint(x: 0, y: contentSize.height - calendarCollectionView.bounds.size.height)
        calendarCollectionView.setContentOffset(targetContentOffset, animated: false)
    }
    
    func updateViewsForRating() {
        ratingLabelView.backgroundColor = RatingColors.getColorFoInt(number: rating)
        ratingLabel.text = "\(rating)"
        ratingSlider.minimumTrackTintColor = RatingColors.getColorFoInt(number: rating)
        ratingSlider.value = Float(rating)
        ratingSlider.thumbTintColor = RatingColors.getColorFoInt(number: rating)
        saveLogButton.backgroundColor = RatingColors.getColorFoInt(number: rating)
        actionsButton.backgroundColor = RatingColors.getColorFoInt(number: rating)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
} // End of class

// MARK: - Extensions

extension HistoricalLogsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CalendarHelper.shared.months.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 42 because there is 7 columns and 6 rows. 6 * 7 = 42
        return 42
    }
    
    // Cell For Item At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configure(indexPath: indexPath, calendar: calendarCollectionView)
        
        return cell
    }
    
    // Did Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Updates Selectedate. The cell has a did set on the isSelected and will update the view based on that
        selectedDate = CalendarHelper.shared.months[indexPath.section].days[CalendarHelper.shared.getIndexForRow(indexPath: indexPath)]
        guard let selectedDate = selectedDate else {return}
        currentLog = LogController.shared.getLogForDate(date: selectedDate)
        if let currentLog = currentLog {
            rating = Int(currentLog.rating)
            updateViewsForRating()
        }
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()
        
        ratingEditStackView.isUserInteractionEnabled = true
        ratingEditStackView.alpha = 1
    }
    
    // MARK: - Flowlayout
    
    // Set size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 7 cells in a row for 7 days, 6 rows for the calendars ability to sometimes reach 6 rows tall
        let size = CGSize(width: calendarCollectionView.frame.width / 7, height: calendarCollectionView.frame.height / 6)
        return size
    }
    
    // Did Scoll. Primary funciton is to update the month and year label when sections are changed
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Sets the month label to the current month in view
        let sectionHeight = scrollView.contentSize.height / CGFloat(CalendarHelper.shared.months.count)
        let section = Int(round(scrollView.contentOffset.y  / sectionHeight))
        if section >= 0 && section < CalendarHelper.shared.months.count {
            monthLabel.text = CalendarHelper.shared.months[section].monthName
            yearLabel.text = CalendarHelper.shared.months[section].year
        }
    }

}
