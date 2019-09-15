//
//  MainMenuView.swift
//  flights
//
//  Created by Aleksandr Gusev on 07/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import UIKit

class MainMenuView: UIViewController {
    
    @IBOutlet weak var departureTextField: UITextField!
    @IBOutlet weak var landingTextField: UITextField!
    @IBOutlet weak var flightDatesTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    @IBAction func findFlightButton(_ sender: Any) {
        let MMController: MainMenuController = .init(departureString: departureTextField.text!,
                                                     landingString: landingTextField.text!,
                                                     dateString: flightDatesTextField.text!)
        MMController.createAndPushData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker.init()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self,
                              action: #selector(MainMenuView.dateChanged(datePicker:)),
                              for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(MainMenuView.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        flightDatesTextField.inputView = datePicker
    }
    
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        /* hide picker */
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        flightDatesTextField.text! = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}
