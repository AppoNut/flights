//
//  DisplayDataView.swift
//  flights
//
//  Created by Aleksandr Gusev on 08/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import UIKit

class DisplayDataView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var displayDataTableView: UITableView!
    // need to get rowsCount from realm base
    var rowsCount: Int = 1
    var DDController: DisplayDataController = DisplayDataController()
    var dataToShow = [String]()
    override func viewDidLoad() {
        
        self.displayDataTableView.delegate = self
        self.displayDataTableView.dataSource = self
        
        dataToShow = DDController.getDbContent()
        print("data to show count \(dataToShow.count)")
        
        super.viewDidLoad()
        navigationItem.title = "Activity"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // returns next displaying table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableview cellForRowAt \(indexPath.row)")
        var cell = tableView.dequeueReusableCell(withIdentifier: "basicTableViewCell")
        if cell == nil {
            // if cell doesn't exist -> create it
            cell = UITableViewCell(style: .default, reuseIdentifier: "basicTableViewCell")
        }
        //cell?.textLabel?.text = "This is \(indexPath.row) cell"
        if indexPath.row != 0 {
            cell?.textLabel?.text = "This is \(dataToShow[indexPath.row]) cell"
        }
        return cell!
    }
    
    // count of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    
}
