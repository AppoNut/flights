//
//  MainMenuController.swift
//  flights
//
//  Created by Aleksandr Gusev on 07/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import SwiftSoup
import RealmSwift

struct flightInfoStruct {
    var departureTime: String
    var landingTime: String
    var flightNum: String
    var planeName: String
    var flightDirect: String
    var flightTime: String
    var price: String
}

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
    
    var parsedFlights = [flightInfoStruct].init()
    var formattedString: String = ""
    var timePairArray = [String].init()
    var flag = false
    
    var flightsArray = [String].init()
    var iataSourceCode: String = ""
    var iataDestCode: String = ""
    
    var beginDate: String = ""
    var endDate: String = ""
    var mainMenuLogging: Logging = Logging()
    

    func setIataSourceCode(value: String) {
        iataSourceCode = value
    }
    
    func setIataDestCode(value: String) {
        iataDestCode = value
    }
    
    func getIataSourceCode() -> String {
        return iataSourceCode
    }
    
    func getIataDestCode() -> String {
        return iataDestCode
    }
    
    init (departureString: String, landingString: String, dateString: String) {
        departure = departureString
        landing = landingString
        date = dateString
        mainMenuLogging.setLoggingStatus(newStatus: false)
    }

    func passBeginEndDate(begin: String, end: String) {
        beginDate = begin
        endDate = end
        
        if begin == "" {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            beginDate = formatter.string(from: date)
        }
        if end == "" {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            endDate = formatter.string(from: date)
        }
        var res = beginDate.split(separator: "/")
        beginDate = String(res[2] + res[1] + res[0])
        
        res = endDate.split(separator: "/")
        if endDate != "" {
            endDate = String(res[2] + res[1] + res[0])
        }
        else {
            endDate = ""
        }
    }
    
    func getIataAirportCodeFromCityName(departure: String,
                                        landing: String,
                                        callback: @escaping (String, String) -> Void) {
        var callbackUrl: String = ""

        let convertedDeparture = departure.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let convertedLanding = landing.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        var urlString = "https://www.travelpayouts.com/widgets_suggest_params?q=From%20" + convertedDeparture! + "%20to%20" + convertedLanding!
        
        let url = URL(string: urlString)

        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil || data == nil {
                self.mainMenuLogging.logToConsole(logMessage: "Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                self.mainMenuLogging.logToConsole(logMessage: "Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                self.mainMenuLogging.logToConsole(logMessage: "Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.mainMenuLogging.logToConsole(logMessage: "json: \(json)")
                if let origin = json["origin"] as? [String : Any] {
                    if let iata = origin["iata"] {
                        self.mainMenuLogging.logToConsole(logMessage: "origin iata code : [\(iata)]")
                        self.iataSourceCode = iata as! String
                    }
                }
                if let destination = json["destination"] as? [String : Any] {
                    self.mainMenuLogging.logToConsole(logMessage: "dest value: [\(destination)]")
                    if let iata = destination["iata"] {
                        self.mainMenuLogging.logToConsole(logMessage: "dest iata code : [\(iata)]")
                        self.iataDestCode = iata as! String
                    }
                }
                callback("\(self.iataSourceCode)","\(self.iataDestCode)")
            } catch {
                self.mainMenuLogging.logToConsole(logMessage: "JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }

    func loadPage (src: String, dst: String) {
        self.mainMenuLogging.logToConsole(logMessage: "loadPage src[\(src)] dst[\(dst)]")
        var departureTime: String = ""
        var landingTime: String = ""
        var flightId: String = ""
        var planeId: String = ""
        var flightDirection: String = ""
        var foundFlightTime: String = ""
        var foundPrice: String = ""
        var array: String = ""

        var concatSite = "https://pegasfly.com/Search/SearchResult?q=1000-0-"
        concatSite = concatSite + src + dst
        concatSite = concatSite + beginDate
        concatSite = concatSite + dst + src
        concatSite = concatSite + endDate
        self.mainMenuLogging.logToConsole(logMessage: "concatinated string [\(concatSite)]")

        if let url = URL(string: concatSite) {
            do {
                let myHTMLString = try String(contentsOf: url)
                let doc: Document = try SwiftSoup.parse(myHTMLString)
                let divArray = try doc.select("div").array()
                let test = try doc.select("div").array()
                for i in 0..<test.count {
                    let className: String = try test[i].className()
                    if className == "js-FlightRow" {
                        self.mainMenuLogging.logToConsole(logMessage: "found something")
                        // in-out time
                        let time2 = try test[i].getElementsByClass("SearchResult_TableCell-Time").array()
                        for j in 0..<time2.count {
                            array = detectHtmlTagBracers(inputString: "in out time \(time2[j])")
                            
                            if (j+1) % 2 == 0 && flag == true {
                                formattedString = formattedString + " " + array
                                flag = false
                                timePairArray.append(formattedString)
                                landingTime = array
                            }
                            else {
                                flag = true
                                formattedString = array
                                departureTime = array
                            }
                        }
                        
                        let flightNum = try test[i].getElementsByClass("SearchResult_TableCell-FlightName").array()
                        for j in 0..<flightNum.count {
                            array = detectHtmlTagBracers(inputString: "flight num \(flightNum[j])")
                        }
                        formattedString = formattedString + " " + array
                        flightId = array
                        self.mainMenuLogging.logToConsole(logMessage: "flightNum array: [\(array)]")
                        
                        let planeName = try test[i].getElementsByClass("SearchResult_TableCell-PlaneName").array()
                        for j in 0..<planeName.count {
                            array = detectHtmlTagBracers(inputString: "planeName \(planeName[j])")
                        }
                        formattedString = formattedString + " " +  array
                        self.mainMenuLogging.logToConsole(logMessage: "planeName array: [\(array)]")
                        planeId = array

                        let flightDirect = try test[i].getElementsByClass("SearchResult_TableCell-FlightDirect").array()
                        for j in 0..<flightDirect.count {
                            array = detectHtmlTagBracers(inputString: "flightDirect \(flightDirect[j])")
                        }
                        formattedString = formattedString + " " +  array
                        flightDirection = array
                        self.mainMenuLogging.logToConsole(logMessage: "flightDirect array: [\(array)]")

                        
                        let flightTime = try test[i].getElementsByClass("SearchResult_TableCell-FlightTime").array()
                        for j in 0..<flightTime.count {
                            array = detectHtmlTagBracers(inputString: "flightTime \(flightTime[j])")
                        }
                        formattedString = formattedString + " " +  array
                        self.mainMenuLogging.logToConsole(logMessage: "flightTime array: [\(array)]")
                        foundFlightTime = array

                        let price = try test[i].select("price").array()
                        for j in 0..<price.count {
                            let span = try price[j].select("span").first()!
                                array = detectHtmlPrice(inputString: "\(span)")
                            /* the chipest is the first one */
                            break
                        }
                        formattedString = formattedString + " " +  array
                        self.mainMenuLogging.logToConsole(logMessage: "price array: [\(array)]")
                        foundPrice = array
                        
                        self.mainMenuLogging.logToConsole(logMessage: "next")
                        self.mainMenuLogging.logToConsole(logMessage:
                            "result of formatted string {\(formattedString)}")

                        if (departureTime != "" && landingTime != "" &&
                            flightId != "" && planeId != "" && flightDirection != "" &&
                            foundFlightTime != "" && foundPrice != "" && departure != "" &&
                            landing != "") {
                            parsedFlights.append(flightInfoStruct(departureTime: departureTime,
                                                                  landingTime: landingTime,
                                                                  flightNum: flightId,
                                                                  planeName: planeId,
                                                                  flightDirect: flightDirection,
                                                                  flightTime: foundFlightTime,
                                                                  price: foundPrice))
                        }
                    }
                }
                self.mainMenuLogging.logToConsole(logMessage: " <\(array)>")
            } catch let error {
                self.mainMenuLogging.logToConsole(logMessage: "error: [\(error)]")
            }
        }
        self.mainMenuLogging.logToConsole(logMessage:
            "===== at the end: parsedFlights count [\(parsedFlights.count)]")
        self.mainMenuLogging.logToConsole(logMessage: "====== <\(parsedFlights)>")
    }
    
    func detectHtmlTagBracers(inputString: String) -> String {
        /* remove char array and do it using strings only */
        var array = [Character]()
        
        if inputString.count > 0 {
            var waitClosingBracers = false
            var firstBraces = false
            
            // for everything exept one
            for strChar in inputString {
                if strChar == "\n" && firstBraces == false {
                    firstBraces = true
                    continue
                }
                
                if strChar == "\n" && firstBraces == true {
                    firstBraces = false
                    break
                }
                
                if firstBraces == true && strChar != " " {
                    self.mainMenuLogging.logToConsole(logMessage: "char: \(strChar)")
                    array.append(strChar)
                }
            }
            
            self.mainMenuLogging.logToConsole(logMessage: "final array: [\(array)]{\(array.count)}")
        }
        
        return String(array)
    }
    
    func detectHtmlPrice(inputString: String) -> String {
        self.mainMenuLogging.logToConsole(logMessage: "detectHtmlPrice")
        var array = [Character]()
        var waitForClosing = false

        //for price tag
        for strChar in inputString {
            if strChar == ">" {
                waitForClosing = true
                continue
            }
            if strChar == "<" && waitForClosing == true {
                waitForClosing = false
                break
            }
            if waitForClosing == true && strChar != " " {
                array.append(strChar)
            }
        }
        self.mainMenuLogging.logToConsole(logMessage: "price array: [\(array)]{\(array.count)}")
        self.mainMenuLogging.logToConsole(logMessage: "========")
        return String(array)
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

    func createAndPushData() -> Bool {
        self.mainMenuLogging.logToConsole(logMessage: "createAndPushData")
        var flight: Flight?
        
/*
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
 */

        self.mainMenuLogging.logToConsole(logMessage:
            "parsedFlights.count \(parsedFlights.count) [\(parsedFlights)]")
        
        if parsedFlights.count == 0 {
            return false
        }
        
        for i in 0..<parsedFlights.count {
                flight = .init(flightIndex:     parsedFlights[i].flightNum,
                               aiportSource:    departure,
                               airportDest:     landing,
                               departureTime:   parsedFlights[i].departureTime,
                               landingTime:     parsedFlights[i].landingTime,
                               price:           parsedFlights[i].price)
            flight!.createBase()
            if flight!.isEnryExist(inputFlightId: parsedFlights[i].flightNum,
                                   inputAiportSource: departure,
                                   inputAirportDest: landing,
                                   inputDepartureTime: parsedFlights[i].departureTime,
                                   inputLandingTime: parsedFlights[i].landingTime,
                                   inputPrice: parsedFlights[i].price) == false {
                flight!.saveToBase()
            }
        }
        return true
    }

}
