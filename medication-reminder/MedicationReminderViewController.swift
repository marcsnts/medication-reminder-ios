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
        
        self.tableView.reloadData()
    
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
        print("selected \(date)")
        let customDate = CustomDate(fromDate: date)
        sortUpcomingMissedCompleted(atDate: customDate)
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
            cell.setLabelText(text: "UPCOMING \(upcomingMedicationsArray[indexPath.row].name!)")
        }
        else if indexPath.section == 1 {
            cell.setLabelText(text: "MISSED \(missedMedicationsArray[indexPath.row].name!)")
        }
        else {
            cell.setLabelText(text: "COMPLETED \(completedMedicationsArray[indexPath.row].name!)")
        }
        
        return cell
    }
    
}
