//
//  MedicationReminderViewController.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-21.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import FSCalendar
import SnapKit
import SwiftyJSON

class MedicationReminderViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func today(_ sender: Any) {
        calendar.select(Date())
        self.sortUpcomingMissedCompleted(atDate: CustomDate(fromDate: Date()))
    }
    
    var medicationsDictionary = [CustomDate: [Medication]]()
    var missedMedicationsArray = [Medication]()
    var completedMedicationsArray = [Medication]()
    var upcomingMedicationsArray = [Medication]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMedicationsFromAPI()
        setupNavBar()
        setupCalendar()
        setupTableView()
        setupConstraints()
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkUpcomingTimes), userInfo: nil, repeats: true)

    }
    
    private func refreshCells() {
        let cells = self.tableView.visibleCells
        
        for cell in cells {
            if let cell = cell as? MedicationTableViewCell {
                if cell.updateCellUI() {
                    if let indexPath = self.tableView.indexPath(for: cell) {
                        self.tableView.beginUpdates()
                        //only cells in upcoming section will ever update
                        if let completed = cell.medication?.completed {
                            if completed {
                                self.tableView.moveRow(at: indexPath, to: IndexPath(row: self.tableView.numberOfRows(inSection: 2)-1, section: 2))
                                self.completedMedicationsArray.insert(upcomingMedicationsArray.remove(at: indexPath.row), at: completedMedicationsArray.count-1)
                            }
                            else {
                                if let missed = cell.medication?.missed {
                                    if missed {
                                        self.tableView.moveRow(at: indexPath, to: IndexPath(row: self.tableView.numberOfRows(inSection: 1)-1, section: 1))
                                        self.completedMedicationsArray.insert(upcomingMedicationsArray.remove(at: indexPath.row), at: missedMedicationsArray.count-1)
                                    }
                                }
                            }
                        }
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        self.tableView.endUpdates()
                    }
                }
                
            }
        }
    }
    
    func checkUpcomingTimes() {
        let now = Date()
        let date = CustomDate(fromDate: now)
        guard let medicationsArray = medicationsDictionary[date] else {
            print("No medications found at \(date.toString())")
            return
        }
        
        for medication in medicationsArray {
            if let completed = medication.completed, let time = medication.time {
                if !completed {
                    let now = Date()
                    if !medication.takeable {
                        //Not using exactly 5 minutes so we allow the app a small margin for error
                        let fiveMin = Double(60*5+Constants.REFRESH_ERROR_MARGIN)
                        if now >= time.addingTimeInterval(-1.00*fiveMin) && now <= time.addingTimeInterval(fiveMin) {
                            medication.takeable = true
                        }
                    }
                    else {
                        //It's medication time!!
                        if now >= time.addingTimeInterval(-1.00*Constants.REFRESH_ERROR_MARGIN) && now <= time.addingTimeInterval(Constants.REFRESH_ERROR_MARGIN) {
                            Sound.play(type: .chime, repeats: nil)
                        }
                        
                        //Time exceeds 5 minutes
                        if now > time.addingTimeInterval(Double(60*5+Constants.REFRESH_ERROR_MARGIN)) {
                            medication.takeable = false
                            Sound.play(type: .alarm, repeats: 10)
                        }
                    }
                    refreshCells()
                }
            }
        }
    }
    
    private func loadMedicationsFromAPI() {
   
        NetworkRequest.getMedications(startDate: Constants.START_DATE, endDate: Constants.END_DATE, successHandler: { (json) -> Void in
            for i in 0..<json.count {
                let newMedication = Medication(fromJSON: json[i])
                newMedication.createLocalNotification()
                if let medTime = newMedication.time {
                    let customMedicationDate = CustomDate(fromDate: medTime)
                    //if the date already exists append to medication array otherwise add new entry to dictionary
                    if self.medicationsDictionary[customMedicationDate] != nil {
                        self.medicationsDictionary[customMedicationDate]!.append(newMedication)
                    }
                    else {
                        self.medicationsDictionary[customMedicationDate] = [newMedication]
                    }
                }
            }
            //Initial sort
            self.sortUpcomingMissedCompleted(atDate: CustomDate(fromDate: Date()))
        })
        
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "MedicationTableViewCell", bundle: nil), forCellReuseIdentifier: "MedicationCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupCalendar() {
        self.calendar.select(Date())
        self.calendar.scope = .week
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.appearance.weekdayTextColor = Color.MavencareBlue
        self.calendar.appearance.headerTitleColor = Color.MavencareBlue
    }
    
    private func setupNavBar() {
        self.title = "Medication Reminder"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Color.MavencareBlue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]
    }
    
    private func setupConstraints() {
        self.calendar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.height.equalTo(200)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(self.calendar.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func sortUpcomingMissedCompleted(atDate: CustomDate) {
        
        completedMedicationsArray = []
        upcomingMedicationsArray = []
        missedMedicationsArray = []
        
        guard let medicationsArray = medicationsDictionary[atDate] else {
            print("No medications found at \(atDate.toString())")
            self.tableView.reloadData()
            return
        }
        
        for medication in medicationsArray {
            if let completed = medication.completed {
                if completed {
                    completedMedicationsArray.append(medication)
                }
                else {
                    if medication.missed {
                        missedMedicationsArray.append(medication)
                    }
                    else {
                        upcomingMedicationsArray.append(medication)
                    }
                }
            }
        }
        missedMedicationsArray.sort(by: ascendingTimeSort)
        upcomingMedicationsArray.sort(by: ascendingTimeSort)
        completedMedicationsArray.sort(by: ascendingTimeSort)
        self.tableView.reloadData()
    
    }
    
    func ascendingTimeSort(medication1: Medication, medication2: Medication) -> Bool {
        guard let time1 = medication1.time, let time2 = medication2.time else {
            return false
        }
        
        return time1 < time2
    }
    
}

//CALENDAR DELEGATE
extension MedicationReminderViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        sortUpcomingMissedCompleted(atDate: CustomDate(fromDate: date))
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Constants.END_DATE
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Constants.START_DATE
    }
    
}

//TABLEVIEW DELEGATE
extension MedicationReminderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return upcomingMedicationsArray.count
        }
        else if section == 1 {
            return missedMedicationsArray.count
        }
        return completedMedicationsArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = ["Upcoming Medications", "Missed Medications", "Taken Medications"]
        return sectionTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath) as! MedicationTableViewCell
        
        if indexPath.section == 0 {
            cell.setupCell(medication: upcomingMedicationsArray[indexPath.row], status: .upcoming)
        }
        else if indexPath.section == 1 {
            cell.setupCell(medication: missedMedicationsArray[indexPath.row], status: .missed)
        }
        else {
            cell.setupCell(medication: completedMedicationsArray[indexPath.row], status: .completed)
        }
        
        return cell
    }
    
}
