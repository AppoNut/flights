//
//  MainMenuController.swift
//  flights
//
//  Created by Aleksandr Gusev on 07/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import SwiftSoup


class MainMenuController {
    
    private var departure : String = ""
    private var landing : String = ""
    private var date : String = ""
    private var departureDate : String = ""
    private var landingDate: String = ""
    
    /* Variables for test dataset */
    var testFlightNum = [String]()
    var testAirportSrc = [String]()
    var testAirportDst = [String]()
    var testDepartuteTime = [String]()
    var testLandingTime = [String]()
    var testPrice = [String]()
    var testArraySize: Int = 4
    
    init (departureString: String, landingString: String, dateString: String) {
        departure = departureString
        landing = landingString
        date = dateString
    }
 
    /* Create test dataset while website parsing is not ready */
    func fillTestArrays() {
        testFlightNum.append("S7 182")
        testAirportSrc.append("OBV")
        testAirportDst.append("DME")
        testDepartuteTime.append("05:50")
        testLandingTime.append("06:10")
        testPrice.append("42000")
        
        testFlightNum.append("N4-177")
        testAirportSrc.append("SVO")
        testAirportDst.append("LED")
        testDepartuteTime.append("07:15")
        testLandingTime.append("8.35")
        testPrice.append("2593")
        
        testFlightNum.append("N4-147")
        testAirportSrc.append("SVO")
        testAirportDst.append("LED")
        testDepartuteTime.append("18:20")
        testLandingTime.append("19:50")
        testPrice.append("3493")
        
        testFlightNum.append("N4-336")
        testAirportSrc.append("KRR")
        testAirportDst.append("GYD")
        testDepartuteTime.append("16:30")
        testLandingTime.append("19:40")
        testPrice.append("14403")
        
        if departure != "" && landing != "" {
            testFlightNum.append("N1-555")
            testAirportSrc.append(departure)
            testAirportDst.append(landing)
            testDepartuteTime.append("06:30")
            testLandingTime.append("19:40")
            testPrice.append("104403")
            testArraySize = 5
        }
    }

    func createAndPushData() {
        var flight: Flight?
        
        self.fillTestArrays()

        for i in 0..<testArraySize {
            flight = .init(flightIndex:     testFlightNum[i],
                           aiportSource:    testAirportSrc[i],
                           airportDest:     testAirportDst[i],
                           departureTime:   testDepartuteTime[i],
                           landingTime:     testLandingTime[i],
                           price:           testPrice[i])
            flight!.createBase()
            flight!.saveToBase()
        }
    }
    
}
