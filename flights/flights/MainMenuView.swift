//
//  MainMenuView.swift
//  flights
//
//  Created by Aleksandr Gusev on 07/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class MainMenuView: UIViewController {
    
    @IBOutlet weak var departureTextField: UITextField!
    @IBOutlet weak var landingTextField: UITextField!
    @IBOutlet weak var flightDatesTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    @IBAction func findFlightButton(_ sender: Any) {
        var MMController: MainMenuController = .init(departureString: departureTextField.text!, landingString: landingTextField.text!, dateString: flightDatesTextField.text!)
        MMController.loadPage()
        var localWebview: WKWebView = MMController.getWebView()
        view.addSubview(localWebview)
        print("something happened")
        
        MMController.getWebData()
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "displayDataStoryboard"))!
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker.init()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(MainMenuView.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainMenuView.tapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        flightDatesTextField.inputView = datePicker
        // Do any additional setup after loading the view.
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
