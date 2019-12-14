//
//  DateDisplayCell.swift
//  InlineDatePicker
//
//  Created by Terry Dengis on 11/16/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import UIKit

protocol DateDisplayDelegate: class {
    func didChangeDate(date: Date)
}

class DateDisplayCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: DateDisplayDelegate?
    var datePickerCell : DatePickerCell?
    
    var dateFormat : DateFormatType = .reverseDate
    var displayedDate = Date ()
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DateDisplayCellIdentifier"
    }
    
    @IBAction func previousDay(_ sender: Any) {
        if let newDate = Calendar.current.date (byAdding: .day, value: -1, to: displayedDate) {
            updateText(date: newDate)
            delegate?.didChangeDate(date: displayedDate)
        }
    }
    
    @IBAction func nextDay(_ sender: Any) {
        if let newDate = Calendar.current.date (byAdding: .day, value: 1, to: displayedDate) {
            updateText(date: newDate)
            delegate?.didChangeDate(date: displayedDate)
        }
    }
    
    
    // Nib name
    class func nibName() -> String {
        return "DateDisplayCell"
    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 44.0
    }

    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Update text
    func updateText(date: Date) {
        displayedDate = date
        dateLabel.text = date.convertToString(dateformat: dateFormat)
        //delegate?.didChangeDate(date: displayedDate)
    }

}
