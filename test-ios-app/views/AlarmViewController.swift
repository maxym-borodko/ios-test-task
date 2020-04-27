//
//  ViewController.swift
//  test-ios-app
//
//  Created by Maxym Borodko on 26.04.2020.
//  Copyright © 2020 Maxym Borodko. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var sleepTimeButton: UIButton!
    @IBOutlet var alarmButton: UIButton!
    @IBOutlet var changeStateButton: UIButton!
    
    var viewModel: AlarmViewModel = AlarmViewModel()
    
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.state.bind({ [unowned self] state in
            self.stateLabel.text = state
        })
        
        viewModel.sleepTime.bind({ [unowned self] sleepTime in
            self.sleepTimeButton.setTitle(sleepTime, for: .normal)
        })
        
        viewModel.alarmTime.bind({ [unowned self] alarmTime in
            self.alarmButton.setTitle(alarmTime, for: .normal)
        })
        
        viewModel.actionTitle.bind({ [unowned self] action in
            self.changeStateButton.setTitle(action, for: .normal)
        })
        
        viewModel.alarmEvent = { [unowned self] in
            self.presentAlarmWentOff()
        }
    }
    
    // MARK: - Actions
    @IBAction func onChangeSleepTime() {
        presentSleepTimes()
    }
    
    @IBAction func onChangeAlarmTime() {
        presentAlarm()
    }
    
    @IBAction func onChangeState() {
        viewModel.changeState()
    }
    
    //
    private func presentSleepTimes() {
        let sheet = UIAlertController.sleepTimeSheetControllerWith(sleepTimes: viewModel.sleepTimeValues)
        { [unowned self] (index) in
            self.viewModel.setSleepTimeAt(index: index)
        }
        
        present(sheet, animated: true)
    }
    
    private func presentAlarm() {
        let datePickerController = UIAlertController.datePickerViewController
        { [unowned self] (date) in
            self.viewModel.setAlarm(dateTime: date)
        }
        
        self.present(datePickerController, animated: true, completion: nil)
    }
    
    private func presentAlarmWentOff() {
        let alertController = UIAlertController.alarmWentOffController
        { [unowned self] in
            self.viewModel.changeState()
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
