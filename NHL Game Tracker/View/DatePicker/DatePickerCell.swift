//
//  DatePickerCell.swift
//  InlineDatePicker
//
//  Created by Terry Dengis on 11/16/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {
    func didChangeDate(date: Date)
}

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DatePickerDelegate?
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DatePickerCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "DatePickerCell"
    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 160.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        datePicker.datePickerMode = .date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initView() {
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }

    func upDateDisplayCell(date: Date) {
        datePicker.setDate(date, animated: true)
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        
        delegate?.didChangeDate(date: sender.date)
    }
}
