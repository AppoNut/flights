//
//  DisplayDataController.swift
//  flights
//
//  Created by Aleksandr Gusev on 08/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation

class DisplayDataController {
    var flight: Flight = .init()
    
    func getDbContent() -> [String] {
        var array = [(aiportSource:String,
                      airportDest:String,
                      departureTime:String,
                      landingTime:String,
                      price:String)]()
        flight.getFromBaseByFlightName(flightName: "S7 182", array: &array)
        
        if array.count != 0 {
            print("count: \(array.count)")
        } else {
            print("array count is zero")
        }

        var stringArray = [String]()
        for i in 0..<array.count {
            stringArray.append("S7 182 " + array[i].aiportSource + " " +
                                array[i].airportDest + " " + array[i].departureTime + " " +
                                array[i].landingTime + " " + array[i].price)
        }
        return stringArray
    }

    //flight
}
