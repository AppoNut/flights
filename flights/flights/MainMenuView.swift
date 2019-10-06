//
//  MainMenuView.swift
//  flights
//
//  Created by Aleksandr Gusev on 07/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

class MainMenuView: UIViewController {
    
    @IBOutlet weak var departureTextField: UITextField!
    @IBOutlet weak var landingTextField: UITextField!
    @IBOutlet weak var flightDatesTextField: UITextField!
    @IBOutlet weak var flightBackDatesTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    private var datePicker2: UIDatePicker?
    var firstField = false
    var secondField = false
    
    @IBAction func vkLogOutUserButton(_ sender: UIButton) {
        VKSdk.forceLogout()
        displayVkAuthController()
    }
    
    func displayVkAuthController() {
        let newController = self.storyboard?.instantiateViewController(withIdentifier: "authorizeView") as! VkAuthorizeView
        self.present(newController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "testSegue" {
            let vc = segue.destination as? DisplayDataView

            if self.departureTextField.text != "" {
                vc?.departureText = self.departureTextField.text!
            }
            else {
                vc?.departureText = ""
            }
            
            if self.landingTextField.text != "" {
                vc?.landingText = self.landingTextField.text!
            }
            else {
                vc?.landingText = ""
            }
            
            if self.flightDatesTextField.text != "" {
                vc?.flightDatesText = self.flightDatesTextField.text!
            }
            else {
                vc?.flightDatesText = ""
            }
            
            if self.flightBackDatesTextField.text != "" {
                vc?.flightBackDatesText = self.flightBackDatesTextField.text!
            }
            else {
                vc?.flightBackDatesText = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flightDatesTextField.delegate = self
        flightBackDatesTextField.delegate = self
        
        datePicker = UIDatePicker.init()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self,
                              action: #selector(MainMenuView.dateChanged(datePicker:)),
                              for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(MainMenuView.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        flightDatesTextField.inputView = datePicker
        flightBackDatesTextField.inputView = datePicker
        
    }
    
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        /* hide picker */
        view.endEditing(true)
        firstField = false
        secondField = false
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        //print("firstField \(firstField) second \(secondField)")
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if firstField == true {
            flightDatesTextField.text! = dateFormatter.string(from: datePicker.date)
            firstField = false
        } else if secondField == true {
            flightBackDatesTextField.text! = dateFormatter.string(from: datePicker.date)
            secondField = false
        }
        //print("date: \(datePicker.date) dateFormatter: \(dateFormatter.string(from: datePicker.date))")
        view.endEditing(true)
    }

}

extension MainMenuView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == flightDatesTextField {
            //print("flightDatesTextField")
            firstField = true
        } else if textField == flightBackDatesTextField {
            //print("flightBackDatesTextField")
            secondField = true
        }
    }
}
