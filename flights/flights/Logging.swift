//
//  Logging.swift
//  flights
//
//  Created by Aleksandr Gusev on 06/10/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation

class Logging {
    private var loggingStatus: Bool = false
    
    func setLoggingStatus(newStatus: Bool) {
        loggingStatus = newStatus
    }
    
    func getLoggingStatus() -> Bool {
        return loggingStatus
    }
    
    func logToConsole(logMessage: String) {
        if (loggingStatus == true) {
            print("Log module: \(logMessage)")
        }
    }
    
}
