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

    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var medicationDosageLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    var medication: Medication?
 
    @IBAction func takeMedication(_ sender: Any) {
        
        guard let medication = self.medication, let id = medication.id else {
            print("Medication for cell not set")
            return
        }
        
        let d = [
            "m" : Date().iso8601String,
            "c" : nil
        ]
        let body: [String:Any] = [
            "completed" : true,
            "d" : d
        ]
        
        NetworkRequest.patchMedication(medicationId: id, params: body, successHandler: { (json) -> Void in
            medication.completed = true
        })
    }
    
    //Returns true if UI changed else false
    func updateCellUI() -> Bool {
        guard let medication = medication else {
            return false
        }
    
        if medication.takeable {
            //No changes
            if statusImageView.isHidden && !takeButton.isHidden {
                return false
            }
            statusImageView.isHidden = true
            takeButton.isHidden = false
        }
        else {
            //No changes
            if !statusImageView.isHidden && takeButton.isHidden {
                return false
            }
            statusImageView.isHidden = false
            takeButton.isHidden = true
        }
        
        return true
        
    }
    
    func setupCell(medication: Medication, status: MedicationStatus) {
        
        self.medication = medication
        
        var image: UIImage?
        switch status {
        case .completed:
            image = UIImage(named: "checkmark")
        case .missed:
            image = UIImage(named: "red-x")
        case .upcoming:
            image = UIImage(named: "warning")
        }
        
        statusImageView.image = image
        
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
        
        takeButton.isHidden = true
        takeButton.tintColor = Color.MavencareBlue
        
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
        
        takeButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
