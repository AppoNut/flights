//
//  MainMenuController.swift
//  flights
//
//  Created by Aleksandr Gusev on 07/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import SwiftSoup

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
    //var beginDate: String = ""
    //var endDate: String = ""
    
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
        //print("res : [\(res)]")
        beginDate = String(res[2] + res[1] + res[0])
        //print("beginDate \(beginDate)")
        
        res = endDate.split(separator: "/")
        //print("res : [\(res)]")
        if endDate != "" {
            endDate = String(res[2] + res[1] + res[0])
        }
        else {
            endDate = ""
        }
        //print("endDate \(endDate)")
    }
    
    func getIataAirportCodeFromCityName(departure: String, landing: String, callback: @escaping (String, String) -> Void){
        var callbackUrl: String = ""
        
        //print("depa: \(departure.count) [\(departure)]")

        let convertedDeparture = departure.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let convertedLanding = landing.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //print("result: \(result)")
        
        var urlString = "https://www.travelpayouts.com/widgets_suggest_params?q=From%20" + convertedDeparture! + "%20to%20" + convertedLanding!
        
        let url = URL(string: urlString)

        let session = URLSession.shared
        //print("URL: \(urlString)")
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil || data == nil {
                //print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                //print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                //print("Wrong MIME type!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                //print("json: \(json)")
                if let origin = json["origin"] as? [String : Any] {
                    if let iata = origin["iata"] {
                        //print("origin iata code : [\(iata)]")
                        self.iataSourceCode = iata as! String
                    }
                }
                if let destination = json["destination"] as? [String : Any] {
                    //print("dest value: [\(destination)]")
                    if let iata = destination["iata"] {
                        //print("dest iata code : [\(iata)]")
                        self.iataDestCode = iata as! String
                    }
                }
                callback("\(self.iataSourceCode)","\(self.iataDestCode)")
            } catch {
                //print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }

    func loadPage (src: String, dst: String) {
        print("loadPage src[\(src)] dst[\(dst)]")
        var departureTime: String = ""
        var landingTime: String = ""
        var flightId: String = ""
        var planeId: String = ""
        var flightDirection: String = ""
        var flightTime1: String = ""
        var price1: String = ""
        
        //print("mda parsedFlights {\(parsedFlights.count)}")
        var array: String = ""
        
        //let url = URL(string: "https://pegasfly.com/Search/SearchResult?q=1000-0-SVOLED20190926LEDSVO20191019-1-000")
        //print("src: (\(src)) dst: (\(dst))")
        
        var concatSite = "https://pegasfly.com/Search/SearchResult?q=1000-0-"
        concatSite = concatSite + src + dst
        concatSite = concatSite + beginDate
        concatSite = concatSite + dst + src
        concatSite = concatSite + endDate
        print("concatinated string [\(concatSite)]")

        if let url = URL(string: concatSite) {
            do {
                let myHTMLString = try String(contentsOf: url)
                let doc: Document = try SwiftSoup.parse(myHTMLString)
                let divArray = try doc.select("div").array()
                let test = try doc.select("div").array()
                for i in 0..<test.count {
                    let className: String = try test[i].className()
                    if className == "js-FlightRow" {
                        print("found something")
                        // in-out time
                        let time2 = try test[i].getElementsByClass("SearchResult_TableCell-Time").array()
                        for j in 0..<time2.count {
                            array = detectHtmlTagBracers(inputString: "in out time \(time2[j])")
                            //print("so my array: |\(array)| j{\(j)}")

                            if (j+1) % 2 == 0 && flag == true {
                                formattedString = formattedString + " " + array
                                //print("2 |\(formattedString)|")
                                flag = false
                                timePairArray.append(formattedString)
                                landingTime = array
                            }
                            else {
                                flag = true
                                formattedString = array
                                //print("1 |\(formattedString)|")
                                departureTime = array
                            }
                        }
                        //print("timePairArray: [\(timePairArray)]")
                        //print("formattedString count \(formattedString.count) data [\(formattedString)]")
                        //print("time2 array: [\(array)]")
                        
                        let flightNum = try test[i].getElementsByClass("SearchResult_TableCell-FlightName").array()
                        for j in 0..<flightNum.count {
                            //print("so: {\(flightNum[j])}")
                            array = detectHtmlTagBracers(inputString: "flight num \(flightNum[j])")
                        }
                        formattedString = formattedString + " " + array
                        flightId = array
                        print("flightNum array: [\(array)]")
                        
                        let planeName = try test[i].getElementsByClass("SearchResult_TableCell-PlaneName").array()
                        for j in 0..<planeName.count {
                            //print("so: {\(planeName[j])}")
                            array = detectHtmlTagBracers(inputString: "planeName \(planeName[j])")
                        }
                        formattedString = formattedString + " " +  array
                        print("planeName array: [\(array)]")
                        planeId = array

                        let flightDirect = try test[i].getElementsByClass("SearchResult_TableCell-FlightDirect").array()
                        for j in 0..<flightDirect.count {
                            //print("so: {\(flightDirect[j])}")
                            array = detectHtmlTagBracers(inputString: "flightDirect \(flightDirect[j])")
                        }
                        formattedString = formattedString + " " +  array
                        flightDirection = array
                        print("flightDirect array: [\(array)]")

                        
                        let flightTime = try test[i].getElementsByClass("SearchResult_TableCell-FlightTime").array()
                        for j in 0..<flightTime.count {
                            //print("so: {\(flightTime[j])}")
                            array = detectHtmlTagBracers(inputString: "flightTime \(flightTime[j])")
                        }
                        formattedString = formattedString + " " +  array
                        print("flightTime array: [\(array)]")
                        flightTime1 = array

                        //let price = try test[i].getElementsByClass("").array()
                        let price = try test[i].select("price").array()
                        //print("price: [\(price)]")
                        for j in 0..<price.count {
                            //print("so: {\(price[j])}")
                            let span = try price[j].select("span").first()!
                                //print("span: {\(span)}")
                                array = detectHtmlPrice(inputString: "\(span)")
                            /* the chipest is the first one */
                            break
                            //}
                        }
                        formattedString = formattedString + " " +  array
                        print("price array: [\(array)]")
                        price1 = array
                        
                        print("next")
                        print("result of formatted string {\(formattedString)}")
                        if (departureTime != "" && landingTime != "" &&
                            flightId != "" && planeId != "" && flightDirection != "" &&
                            flightTime1 != "" && price1 != "" && departure != "" &&
                            landing != "") {
                            parsedFlights.append(flightInfoStruct(departureTime: departureTime,
                                                                  landingTime: landingTime,
                                                                  flightNum: flightId,
                                                                  planeName: planeId,
                                                                  flightDirect: flightDirection,
                                                                  flightTime: flightTime1,
                                                                  price: price1))
                        }
                    }
                }
                print(" <\(array)>")


                
            } catch let error {
                //print("error: [\(error)]")
            }
        }
        //print("===== at the end: parsedFlights count [\(parsedFlights.count)]")
        //print("====== <\(parsedFlights)>")
    }
    
    func parseWebSiteSources(byUrl: URL) {
        
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
                    print("char: \(strChar)")
                    array.append(strChar)
                }
            }
            
            print("final array: [\(array)]{\(array.count)}")
        }
        
        return String(array)
    }
    
    func detectHtmlPrice(inputString: String) -> String {
        print("detectHtmlPrice")
        var array = [Character]()
        var waitForClosing = false

        //for price tag
        for strChar in inputString {
            //print("char: \(strChar)")
            if strChar == ">" {
                waitForClosing = true
                continue
            }
            if strChar == "<" && waitForClosing == true {
                waitForClosing = false
                break
            }
            if waitForClosing == true && strChar != " " {
                //print("char: \(strChar)")
                array.append(strChar)
            }
        }
        print("price array: [\(array)]{\(array.count)}")
        print("========")
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

    func createAndPushData() {
        print("createAndPushData")
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

        print("parsedFlights.count \(parsedFlights.count) [\(parsedFlights)]")
        for i in 0..<parsedFlights.count {
            flight = .init(flightIndex:     parsedFlights[i].flightNum,
                           aiportSource:    departure,
                           airportDest:     landing,
                           departureTime:   parsedFlights[i].departureTime,
                           landingTime:     parsedFlights[i].landingTime,
                           price:           parsedFlights[i].price)
            flight!.createBase()
            flight!.saveToBase()
        }
    }
    
}
