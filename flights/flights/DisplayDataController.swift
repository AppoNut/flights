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
        var array = [(flightIndex:String,
                      aiportSource:String,
                      airportDest:String,
                      departureTime:String,
                      landingTime:String,
                      price:String)]()

        flight.getAllFromBase(array: &array)

        var stringArray = [String]()
        for i in 0..<array.count {
            stringArray.append(array[i].flightIndex + " " + array[i].aiportSource + " " +
                                array[i].airportDest + " " + array[i].departureTime + " " +
                                array[i].landingTime + " " + array[i].price)
        }
        return stringArray
    }

}
