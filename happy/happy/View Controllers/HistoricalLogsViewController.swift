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
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    @IBOutlet weak var calendarNavigationItem: UINavigationItem!
    @IBOutlet weak var editLogButton: UIButton!
    
    
    // MARK: - Properties
    
    var rating = 5
    
    // Used to only scroll to the bottom when the view firsts loads.
    var scrolledToBottom = false
    var selectedDate: Date?
    var currentLog: Log?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.isPagingEnabled = true
        calendarCollectionView.showsVerticalScrollIndicator = false
        calendarCollectionView.scrollsToTop = false
        
        // Sets the month label and year label equal to todays date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
//        title = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "yyyy"
//        yearLabel.text = dateFormatter.string(from: date)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarCollectionView.reloadData()
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if scrolledToBottom == false {
            scrolledToBottom = true
            calendarCollectionView.scrollToItem(at: IndexPath(row: 41, section: CalendarHelper.shared.months.count - 1), at: UICollectionView.ScrollPosition.bottom, animated: false)
            UIView.animate(withDuration: 0.2, animations: {
                self.coverView.alpha = 0.0
            }) { (success) in
                if success {
                    self.coverView.isHidden = true
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let settings = SettingsController.shared.settings else {return .lightContent}
        if settings.darkMode == true {
            return .lightContent
        } else {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func deleteLogButtonTapped(_ sender: Any) {
        presentDeleteLogAlert()
    }
    
    // MARK: - Custom Functions
    
    func presentDeleteLogAlert() {
        let alertController = UIAlertController(title: "Delete Log", message: "Are you sure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let log = self.currentLog else {return}
            let feedback = UINotificationFeedbackGenerator()
            feedback.prepare()
            LogController.shared.deleteLog(log: log, completion: { (success) in
                DispatchQueue.main.async {
                    if success {
                        self.currentLog = nil
                        feedback.notificationOccurred(.success)
                        self.rating = -1
                        self.updateDeleteLogBarButtonItem()
                        self.calendarCollectionView.reloadData()
                        self.updateViewsForRating()
                    } else {
                        feedback.notificationOccurred(.error)
                    }
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func updateDeleteLogBarButtonItem() {
        if currentLog != nil {
            let deleteLogNavigationBarItem = UIBarButtonItem(image: UIImage(named: "deleteIcon"), style: .done, target: self, action: #selector(deleteLogButtonTapped(_:)))
            self.navigationItem.rightBarButtonItem = deleteLogNavigationBarItem
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func updateViews() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        setNeedsStatusBarAppearanceUpdate()
        guard let settings = SettingsController.shared.settings else {return}
        var titleColor: UIColor = UIColor.black
        if settings.darkMode {
            monthLabel.textColor = .white
            yearLabel.textColor = .white
            sundayLabel.textColor = .white
            mondayLabel.textColor = .white
            tuesdayLabel.textColor = .white
            wednesdayLabel.textColor = .white
            thursdayLabel.textColor = .white
            fridayLabel.textColor = .white
            saturdayLabel.textColor = .white
            navigationController?.navigationBar.barTintColor = UIColor.black
            navigationController?.navigationBar.tintColor = .black
            titleColor = .white
        } else {
            monthLabel.textColor = .black
            yearLabel.textColor = .black
            sundayLabel.textColor = .black
            mondayLabel.textColor = .black
            tuesdayLabel.textColor = .black
            wednesdayLabel.textColor = .black
            thursdayLabel.textColor = .black
            fridayLabel.textColor = .black
            saturdayLabel.textColor = .black
            navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.tintColor = .white
            titleColor = .black
            
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Light", size: 17)!, NSAttributedString.Key.foregroundColor : titleColor]
        self.tabBarController?.tabBar.barTintColor = .white
        editLogButton.layer.cornerRadius = editLogButton.frame.height / 2
        editLogButton.layer.borderColor = UIColor.black.cgColor
        editLogButton.layer.borderWidth = 1.5
        editLogButton.isHidden = true
    }
    
    func updateViewsForRating() {
        let color = ColorHelper.getColorFoInt(number: rating)
        editLogButton.backgroundColor = color
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSelectActivities" {
            guard let destinationVC = segue.destination as? SelectActivitiesViewController else {return}
            destinationVC.delegate = self
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
            if let log = currentLog {
                destinationVC.log = log
            } else {
                guard let selectedDate = selectedDate else {return}
                destinationVC.selectedDate = selectedDate
            }
            
        }
    }
    
} // End of class

// MARK: - Extensions

extension HistoricalLogsViewController: SelectActivitiesViewControllerDelegate {
    func setCurrentLog(log: Log?) {
        if let log = log {
            currentLog = log
            rating = log.rating
            updateViewsForRating()
        } else {
            currentLog = nil
            rating = -1
            updateViewsForRating()
        }
        updateDeleteLogBarButtonItem()
    }
}

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
        cell.configure(indexPath: indexPath, calendar: calendarCollectionView, selectedDate: selectedDate)
        
        return cell
    }
    
    // Did Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Updates Selectedate. The cell has a did set on the isSelected and will update the view based on that
        selectedDate = CalendarHelper.shared.months[indexPath.section].days[CalendarHelper.shared.getIndexForRow(indexPath: indexPath)]
        guard let selectedDate = selectedDate else {return}
        currentLog = LogController.shared.getLogForDate(date: selectedDate)
        updateDeleteLogBarButtonItem()
        if let currentLog = currentLog {
            rating = Int(currentLog.rating)
            updateViewsForRating()
        } else {
            rating = -1
            updateViewsForRating()
        }
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.selectionChanged()

        editLogButton.isHidden = false
        calendarCollectionView.reloadData()
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
