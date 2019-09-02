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
    
    // MARK: - Properties
    
    // Used to only scroll to the bottom when the view firsts loads.
    var scrolledToBottom = false
    // Used to upadate the selecte dates value with the LogController
    var selectedDate: Date?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.isPagingEnabled = true
        calendarCollectionView.showsVerticalScrollIndicator = false
        
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
    
    // MARK: - Custom Funcitons
    
    // Used because the most current date is at the bottom of the collections view. I set it to the bottom of the collection view because I think it is more intuitive to the user. Easier user experience
    func scrollToBottom() {
        scrolledToBottom = true
        let contentSize = calendarCollectionView.contentSize
        let targetContentOffset = CGPoint(x: 0, y: contentSize.height - calendarCollectionView.bounds.size.height)
        calendarCollectionView.setContentOffset(targetContentOffset, animated: false)
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configure(indexPath: indexPath, calendar: calendarCollectionView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = CalendarHelper.shared.months[indexPath.section].days[CalendarHelper.shared.getIndexForRow(indexPath: indexPath)]
        
        
    }
    
    // MARK: - Flowlayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 7 cells in a row for 7 days, 6 rows for the calendars ability to sometimes reach 6 rows tall
        let size = CGSize(width: calendarCollectionView.frame.width / 7, height: calendarCollectionView.frame.height / 6)
        return size
    }
    
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
