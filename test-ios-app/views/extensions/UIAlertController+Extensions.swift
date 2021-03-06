//
//  UIAlertController+Extensions.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 27.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import UIKit

typealias SleepTimeCompletion = (Int) -> Void
typealias DatePickerCompletion = (Date) -> Void
typealias AlarmWentOffCompletion = () -> Void

extension UIAlertController {
    static let datePickerHeight: CGFloat = 280.0
    static let addingMinutesToCurrentDate = 1
    
    class func sleepTimeSheetControllerWith(sleepTimes: [SleepTime],
                                            completion: @escaping SleepTimeCompletion) -> UIAlertController {
        
        let sheetController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        sleepTimes.forEach { value in
            let action = UIAlertAction(title: value.stringRepresantative(),
                                       style: .default,
                                       handler: { action in
                                        let index = sheetController.actions.lastIndex(of: action)
                                        completion(index!)
            })
            
            sheetController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel)
        sheetController.addAction(cancelAction)
        
        return sheetController
    }
    
    class func datePickerViewController(_ completion: @escaping DatePickerCompletion) -> UIAlertController {
        let datePicker = UIDatePicker()
        let minutes = UIAlertController.addingMinutesToCurrentDate
        datePicker.minimumDate = Calendar.current.date(byAdding: .minute,
                                                       value: minutes,
                                                       to: Date())
        
        let datePickerSheetController = UIAlertController(title: nil,
                                                          message: nil,
                                                          preferredStyle: .actionSheet)
        
        datePickerSheetController.view.addSubview(datePicker)
        
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: ""),
                                       style: .cancel,
                                       handler: { action in
                                        completion(datePicker.date)
        })
        
        datePickerSheetController.addAction(doneAction)
        
        let heightConstraint: NSLayoutConstraint =
            NSLayoutConstraint(item: datePickerSheetController.view!,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: UIAlertController.datePickerHeight)
        
        datePickerSheetController.view.addConstraint(heightConstraint)
        
        return datePickerSheetController
    }
    
    class func alarmWentOffController(_ completion: @escaping AlarmWentOffCompletion) -> UIAlertController {
        let alarmController = UIAlertController(title: nil,
                                                message: NSLocalizedString("Alarm went off", comment: ""),
                                                preferredStyle: .alert)
        
        let stopAction =
            UIAlertAction(title: NSLocalizedString("Done", comment: ""),
                          style: .default) { (action) in
                            completion()
        }
        
        alarmController.addAction(stopAction)
        
        return alarmController
    }
}
