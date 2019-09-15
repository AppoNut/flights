//
//  DisplayDataView.swift
//  flights
//
//  Created by Aleksandr Gusev on 08/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK

class DisplayDataView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, SwiftyVKSessionDelegate {
    
    @IBOutlet weak var displayDataTableView: UITableView!
    // need to get rowsCount from realm base
    var rowsCount: Int = 1
    var DDController: DisplayDataController = DisplayDataController()
    var dataToShow = [String]()
    var prepareTextToPost: String = ""
    
    func getPreparedString() -> String {
        return prepareTextToPost
    }
    
    func setPreparedString(setUpString: String) {
        prepareTextToPost = setUpString
    }
    
    override func viewDidLoad() {
        self.displayDataTableView.delegate = self
        self.displayDataTableView.dataSource = self
        
        dataToShow = DDController.getDbContent()
        
        super.viewDidLoad()
        navigationItem.title = "Flights info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        rowsCount = dataToShow.count
    }
    
    // returns next displaying table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "basicTableViewCell")
        if cell == nil {
            // if cell doesn't exist -> create it
            cell = UITableViewCell(style: .default, reuseIdentifier: "basicTableViewCell")
        }
        cell?.textLabel?.textAlignment = .center
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
        
        let actionSheet = UIActionSheet(title: "Choose action", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send to Wall")
        actionSheet.show(in: self.view)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch (buttonIndex) {
        case 0:
            // cancel button
            break;
        case 1:
            // send to wall button
            sendPostRequest(inputText: getPreparedString())
            break;
        default:
            break;
        }
    }
    
    func sendPostRequest(inputText: String) {
        
        let vkRelatedData = VkRelatedData.init()
        let version = vkRelatedData.getApiVersion()
        let user_id = vkRelatedData.getUserId()
        let accessToken = vkRelatedData.getToken()

        let postModifiedString = inputText.replacingOccurrences(of: " ", with: "%20")

        let url: URL = URL(string: "https://api.vk.com/method/wall.post?v=\(version)&owner_id=\(user_id)&access_token=\(accessToken)&message=\(postModifiedString)")!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                /* do nothing */
            }
            else {
                /* do nothing */
            }
        }
        task.resume()
        
    }
    
}
