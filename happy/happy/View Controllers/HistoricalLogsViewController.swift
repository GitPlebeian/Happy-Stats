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
    
    var currentSection = 0
    var numCellsInCurrentSection = 0
    var numCellsNotInCurrentSection = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.isPagingEnabled = true
        calendarCollectionView.showsVerticalScrollIndicator = false
//        calendarCollectionView.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarCollectionView.reloadData()
    }
}// End of class

// MARK: - Extensions

extension HistoricalLogsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configure(indexPath: indexPath, calendar: calendarCollectionView)
        
//        if indexPath.section == currentSection && numCellsInCurrentSection <= 42{
//            numCellsInCurrentSection += 1
//            print("In: \(numCellsInCurrentSection) Not: \(numCellsNotInCurrentSection) Section: \(indexPath.section)")
//            numCellsNotInCurrentSection -= 1
//            if numCellsNotInCurrentSection > 0 {
//            }
//        } else {
//            numCellsNotInCurrentSection += 1
//            numCellsInCurrentSection -= 1
//            print("In: \(numCellsInCurrentSection) Not: \(numCellsNotInCurrentSection) Section: \(indexPath.section)")
//        }
//        if numCellsNotInCurrentSection > numCellsInCurrentSection {
//            print("Change to section: \(indexPath.section)")
//            numCellsInCurrentSection = 0
//            numCellsNotInCurrentSection = 0
//            currentSection = indexPath.section
//        }
        
        return cell
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return CalendarHelper.shared.months.count
        return CalendarHelper.shared.months.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    
    // MARK: - Flowlayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: calendarCollectionView.frame.width / 7, height: calendarCollectionView.frame.height / 6)
        return size
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("Did End Dragging")
//    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("Did Begin Dragging")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeight = scrollView.contentSize.height / CGFloat(CalendarHelper.shared.months.count)
        let section = Int(round(scrollView.contentOffset.y  / sectionHeight))
        if section >= 0 && section < CalendarHelper.shared.months.count {
            monthLabel.text = CalendarHelper.shared.months[section].monthName
            yearLabel.text = CalendarHelper.shared.months[section].year
        }
    }
    
}
