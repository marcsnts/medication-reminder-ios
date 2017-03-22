//
//  MedicationTableViewCell.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-21.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SnapKit

enum MedicationStatus {
    case completed, missed, upcoming
}

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var medicationNameLabel: UILabel!
    
    @IBOutlet weak var medicationDosageLabel: UILabel!
    
    func setupCell(medication: Medication, status: MedicationStatus) {
        
        var bgColor = UIColor()
        
        switch status {
        case .completed:
            bgColor = Color.Green
        case .missed:
            bgColor = Color.Red
        case .upcoming:
            bgColor = Color.Orange
        }
        
//        self.backgroundColor = bgColor        
        
        guard let medicationName = medication.name, let medicationDosage = medication.dosage else {
            medicationNameLabel.text = "Unknown"
            medicationNameLabel.text = nil
            return
        }
        
        medicationNameLabel.text = medicationName
        medicationDosageLabel.text = medicationDosage
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        medicationNameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
        }
        
        medicationDosageLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(medicationNameLabel.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(8)
        }
        
        
//        testLabel.snp.makeConstraints { (make) -> Void in
//            make.center.equalToSuperview()
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
