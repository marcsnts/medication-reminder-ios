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
    
    var medicationsDictionary = [Date: [Medication]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.calendar.select(Date())
        self.calendar.scope = .week
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.appearance.weekdayTextColor = Color.MavencareBlue
        self.calendar.appearance.headerTitleColor = Color.MavencareBlue
        self.tableView.register(UINib(nibName: "MedicationTableViewCell", bundle: nil), forCellReuseIdentifier: "MedicationCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupConstraints()
        
        
        ohShit()
    }
    
    private func ohShit() {
        
        let daySeconds = 60*60*24
        
        let startDate = Date(timeIntervalSinceNow: Double(-1 * daySeconds * 18))
        let endDate = Date()
        NetworkRequest.getMedications(startDate: startDate, endDate: endDate, successHandler: { (json) -> Void in
            for i in 0..<json.count {
                let medicationJSON = json[i]
                print(medicationJSON["name"].string)
                
            }
        })
        
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
    
}



























extension MedicationReminderViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
}

extension MedicationReminderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = ["Missed Medications", "Upcoming Medications"]
        return sectionTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath) as! MedicationTableViewCell
        
        if indexPath.section == 0 {
            cell.setLabelText(text: "MISSED \(indexPath)")
        }
        else {
            cell.setLabelText(text: "TAKEN \(indexPath)")
        }
        
        return cell
    }
    
}









