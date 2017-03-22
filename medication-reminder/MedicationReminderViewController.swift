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
        loadMedicationsIntoDictionary()
        setupNavBar()
        setupCalendar()
        setupTableView()
        setupConstraints()
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkUpcomingTimes), userInfo: nil, repeats: true)

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
                    if time.isWithinFiveMinutes(otherDate:now) {
                        
                    }
                }
            }
        }
        
    }
    
    private func loadMedicationsIntoDictionary() {
        
        let daySeconds = 60*60*24
        let startDate = Date()
        let endDate = Date(timeIntervalSinceNow: Double(daySeconds*5))
        
        NetworkRequest.getMedications(startDate: startDate, endDate: endDate, successHandler: { (json) -> Void in
            for i in 0..<json.count {
                let newMedication = Medication(fromJSON: json[i])
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
                    if let time = medication.time {
                        let now = Date()
                        if time.isWithinFiveMinutes(otherDate:now) || time >= now {
                            upcomingMedicationsArray.append(medication)
                        }
                        else {
                            missedMedicationsArray.append(medication)
                        }
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
    
}

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
