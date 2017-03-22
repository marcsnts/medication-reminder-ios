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

class MedicationReminderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.calendar.select(Date())
        self.calendar.scope = .week
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.tableView.isHidden = false
        
        setupConstraints()
        
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
    
    
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }


}
