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
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    var medication: Medication?
 
    func setupCell(medication: Medication, status: MedicationStatus) {
        
        var bgColor = UIColor()
        var image: UIImage?
        switch status {
        case .completed:
            bgColor = Color.Green
            image = UIImage(named: "checkmark")
        case .missed:
            bgColor = Color.Red
            image = UIImage(named: "red-x")
        case .upcoming:
            bgColor = Color.Orange
            image = UIImage(named: "warning")
        }
        
        statusImageView.image = image
        
//        self.backgroundColor = bgColor        
        
        guard let medicationName = medication.name, let medicationDosage = medication.dosage, let medicationTime = medication.time else {
            medicationNameLabel.text = "Unknown"
            medicationNameLabel.text = nil
            return
        }
        
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        medicationNameLabel.text = "\(medicationName) at \(df.string(from: medicationTime))"
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
        
        statusImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
