//
//  DisplayDataView.swift
//  flights
//
//  Created by Aleksandr Gusev on 08/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import UIKit

class DisplayDataView:  UIViewController,
                        UITableViewDelegate,
                        UITableViewDataSource,
                        UIActionSheetDelegate {
    
    @IBOutlet weak var displayDataTableView: UITableView!
    
    var departureText: String = ""
    var landingText: String = ""
    var flightDatesText: String = ""
    var flightBackDatesText: String = ""
    
    var previousDepartureText: String = ""
    var previousLandingText: String = ""
    var previousFlightDatesText: String = ""
    var previousFlightBackDatesText: String = ""
    
    // need to get rowsCount from realm base
    var rowsCount: Int = 1
    var DDController: DisplayDataController = DisplayDataController()
    var dataToShow = [String]()
    var prepareTextToPost: String = ""
    var vSpinner: UIView?
    var hideSpinner: Bool = false
    
    var displayDataLogging: Logging = Logging()
    
    func getPreparedString() -> String {
        return prepareTextToPost
    }
    
    func setPreparedString(setUpString: String) {
        prepareTextToPost = setUpString
    }
    
    override func viewDidLoad() {
        self.displayDataTableView.delegate = self
        self.displayDataTableView.dataSource = self
        
        //dataToShow = DDController.getDbContent()
        
        super.viewDidLoad()
        navigationItem.title = "Flights info"
        self.showSpinner(onView: self.view)
        
        displayDataLogging.setLoggingStatus(newStatus: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        rowsCount = dataToShow.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        rowsCount = dataToShow.count
        
        displayDataLogging.logToConsole(logMessage:
            "dataToShow [\(dataToShow)] rowsCount [\(rowsCount)]")
        
        displayDataLogging.logToConsole(logMessage: "viewWillAppear \(hideSpinner)")
        displayDataLogging.logToConsole(logMessage:
            "departureText [\(departureText)] landingText [\(landingText)] flightDatesText [\(flightDatesText)] flightBackDatesText [\(flightBackDatesText)]")
        
        let MMController: MainMenuController = .init(departureString: departureText,
                                                     landingString: landingText,
                                                     dateString: flightDatesText)
        MMController.passBeginEndDate(begin: flightDatesText,
                                      end: flightBackDatesText)

        MMController.getIataAirportCodeFromCityName(departure: departureText,
                                                    landing: landingText,
                                                    callback: { src, dst in
                                                        self.displayDataLogging.logToConsole(logMessage:
                                                            "callback \(src) \(dst)")
                                                        MMController.loadPage(src: src, dst: dst)
                                                        self.displayDataLogging.logToConsole(logMessage:
                                                            "CREATE AND PUSH DATA from display data view")
                                                        if MMController.createAndPushData() == true {
                                                            self.displayDataLogging.logToConsole(logMessage:
                                                                "FINAL CALLBACK")
                                                            self.dataToShow = self.DDController.getDbContent()
                                                        }
                                                        
                                                        if self.dataToShow.count == 0 {
                                                            self.removeSpinner()
                                                            self.noDataFoundAlert()
                                                        }
                                                        
                                                        self.displayDataLogging.logToConsole(logMessage:
                                                            "[\(self.dataToShow)] [\(self.dataToShow.count)]")
                                                        self.rowsCount = self.dataToShow.count
  
                                                        DispatchQueue.main.async {
                                                            self.removeSpinner()
                                                            if self.rowsCount == 0 {
                                                                self.noDataFoundAlert()
                                                            }
                                                            self.displayDataLogging.logToConsole(logMessage:
                                                                "reloadData")
                                                            self.displayDataTableView.reloadData()
                                                            self.displayDataLogging.logToConsole(logMessage:
                                                                "remove spinner from callback")
                                                            self.displayDataTableView.beginUpdates()
                                                            self.displayDataTableView.endUpdates()
                                                            self.displayDataTableView.reloadData()
                                                        }
                                                    }
        )
    }
    
    func showSpinner(onView: UIView) {
        let spinner = UIView.init(frame: onView.bounds)
        spinner.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinner.center
        
        DispatchQueue.main.async {
            spinner.addSubview(ai)
            onView.addSubview(spinner)
        }
        vSpinner = spinner
    }
    
    func getSpinner () -> UIView {
        return vSpinner!
    }
    
    func removeSpinner() {
        self.displayDataLogging.logToConsole(logMessage:
            "so here we are removeSpinner")
        DispatchQueue.main.async {
            self.displayDataLogging.logToConsole(logMessage:
                "removeSpinner removeFromSuperview")
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
            self.displayDataTableView.reloadData()
        }
        self.displayDataLogging.logToConsole(logMessage: "removeSpinner end")
    }
    
    func removeSpinnerFromView(innerView: UIView) {
        self.displayDataLogging.logToConsole(logMessage: "so here we are removeSpinnerFromView")
        DispatchQueue.main.async {
            self.displayDataLogging.logToConsole(logMessage: "removeSpinnerFromView removeFromSuperview")
            innerView.removeFromSuperview()
        }
        self.displayDataLogging.logToConsole(logMessage: "removeSpinnerFromView end")
    }
    
    // returns next displaying table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "basicTableViewCell")
        if cell == nil {
            // if cell doesn't exist -> create it
            cell = UITableViewCell(style: .default, reuseIdentifier: "basicTableViewCell")
        }
        cell?.textLabel?.textAlignment = .center
        if dataToShow[indexPath.row].count > 38 {
            cell?.textLabel?.font = .systemFont(ofSize: 14)
        } else if dataToShow[indexPath.row].count > 45 {
            cell?.textLabel?.font = .systemFont(ofSize: 10)
        }
        cell?.textLabel?.text = "\(dataToShow[indexPath.row])"

        return cell!
    }
    
    // count of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    
    var selectedRow : Int = -1;
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        setPreparedString(setUpString: dataToShow[selectedRow])
        
        let actionSheet = UIActionSheet(title: "Choose action",
                                        delegate: self,
                                        cancelButtonTitle: "Cancel",
                                        destructiveButtonTitle: nil,
                                        otherButtonTitles: "Send to Wall")
        actionSheet.show(in: self.view)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func actionSheet(_ actionSheet: UIActionSheet,
                     clickedButtonAt buttonIndex: Int) {
        switch (buttonIndex) {
        case 0:
            // cancel button
            break;
        case 1:
            let vkRelatedData = VkRelatedData.init()
            let version = vkRelatedData.getApiVersion()
            let user_id = vkRelatedData.getUserId()
            let accessToken = vkRelatedData.getToken()
            
            if (vkRelatedData == nil ||
                version == "" ||
                user_id == "" ||
                accessToken == "")
            {
                errorAlert()
            }
            else
            {
                // send text to wall button
                sendPostRequest(inputText: getPreparedString())
            }
            break;
        default:
            break;
        }
    }
    
    func noDataFoundAlert() {
        let alert = UIAlertController(title: "Notification",
                                      message: "No data found",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: { action in
                                            self.navigationController?.popViewController(animated: true)
                                      }))
        self.present(alert, animated: true, completion:  nil)
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Notification",
                                      message: "Error occurred. Try again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "Notification",
                                      message: "Message has been posted to your wall",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
    
    func sendPostRequest(inputText: String) {
        self.displayDataLogging.logToConsole(logMessage: "sendPostRequest")
        self.displayDataLogging.logToConsole(logMessage: "inputText [\(inputText)]")
        let vkRelatedData = VkRelatedData.init()
        let version = vkRelatedData.getApiVersion()
        let user_id = vkRelatedData.getUserId()
        let accessToken = vkRelatedData.getToken()
        self.displayDataLogging.logToConsole(logMessage: "accessToken [\(accessToken)]")

        let convertedDeparture = inputText.addingPercentEncoding(withAllowedCharacters:
            NSCharacterSet.urlQueryAllowed)
        self.displayDataLogging.logToConsole(logMessage:
            "convertedDeparture: [\(convertedDeparture)][\(convertedDeparture?.count)]")

        let url: URL = URL(string: "https://api.vk.com/method/wall.post?v=\(version)&owner_id=\(user_id)&access_token=\(accessToken)&message=\(convertedDeparture!)")!

        self.displayDataLogging.logToConsole(logMessage: "url [\(url)]")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                self.displayDataLogging.logToConsole(logMessage: "error != nil")
                /* show alert message to user */
                self.errorAlert()
            } else {
                self.successAlert()
            }
        }
        task.resume()
    }

}
