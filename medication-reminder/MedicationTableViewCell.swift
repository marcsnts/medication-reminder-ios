//
//  MedicationTableViewCell.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-21.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SnapKit

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    
    func test() {
        print("ay le mao")
    }
    
    func setLabelText(text: String) {
        testLabel.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        testLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
