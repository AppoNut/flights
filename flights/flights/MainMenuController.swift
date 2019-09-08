//
//  MainMenuController.swift
//  flights
//
//  Created by Aleksandr Gusev on 07/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import WebKit
import SwiftSoup


class MainMenuController {
    
    private var departure : String = ""
    private var landing : String = ""
    private var date : String = ""
    private var departureDate : String = ""
    private var landingDate: String = ""
    
    let webView: WKWebView = .init()
    
    init (departureString: String, landingString: String, dateString: String) {
        departure = departureString
        landing = landingString
        date = dateString
    }
    
    func loadPage () {
        let myURLString = "https://s7.ru"//"https://russia.airlines.aero/"
        //let url = URL(string: "https://s7.ru")
        //let myURLString = "https://ibe.s7.ru/air?execution=e1s1&ibe_conversation=a9207585-1f2a-45b6-84c6-eafb10811be7&id=deeplink&RDMPTN=false&journeySpan=RT&AA1=MOW&AA2=OVB&FLX=false&DA2=MOW&DA1=OVB&useProxyMode=true&SC1=ANY&fromLocal=%D0%9D%D0%BE%D0%B2%D0%BE%D1%81%D0%B8%D0%B1%D0%B8%D1%80%D1%81%D0%BA%2C+%D0%A2%D0%BE%D0%BB%D0%BC%D0%B0%D1%87%D0%B5%D0%B2%D0%BE&CUR=RUB&AP1=CITY_MOW_RU&AP2=AIR_OVB_RU&DP1=AIR_OVB_RU&DP2=CITY_MOW_RU&TA=1&toLocal=%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0%2C+%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F&TC=0&ssdkl=e4e83d12ab1945e19271aa80b0758413&DD1=2019-10-02&searchTypeRed=aviaTicket&DD2=2019-11-06&TI=0&LAN=ru&FSC1=1&FLC=2&FSC2=1&ibe_medium=s7PortalAviaBot"
        let url = URL(string: "https://ibe.s7.ru/air?execution=e1s1&ibe_conversation=a9207585-1f2a-45b6-84c6-eafb10811be7&id=deeplink&RDMPTN=false&journeySpan=RT&AA1=MOW&AA2=OVB&FLX=false&DA2=MOW&DA1=OVB&useProxyMode=true&SC1=ANY&fromLocal=%D0%9D%D0%BE%D0%B2%D0%BE%D1%81%D0%B8%D0%B1%D0%B8%D1%80%D1%81%D0%BA%2C+%D0%A2%D0%BE%D0%BB%D0%BC%D0%B0%D1%87%D0%B5%D0%B2%D0%BE&CUR=RUB&AP1=CITY_MOW_RU&AP2=AIR_OVB_RU&DP1=AIR_OVB_RU&DP2=CITY_MOW_RU&TA=1&toLocal=%D0%9C%D0%BE%D1%81%D0%BA%D0%B2%D0%B0%2C+%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F&TC=0&ssdkl=e4e83d12ab1945e19271aa80b0758413&DD1=2019-10-02&searchTypeRed=aviaTicket&DD2=2019-11-06&TI=0&LAN=ru&FSC1=1&FLC=2&FSC2=1&ibe_medium=s7PortalAviaBot")
        let request = URLRequest(url: url!)
       webView.frame = CGRect(x: 0, y: 0, width: 300, height: 700)
       webView.load(request)
        
        do {
            let myHTMLString = try String(contentsOf: webView.url!)
            print("HTML : \(myHTMLString)")
            print("----------------")
  
            let siteSource : Document = try SwiftSoup.parse(myHTMLString)
            //print("sitesource: \(siteSource)")
            print("byclass: \(try siteSource.getElementsByClass("tariff-data"))")
            let elements = try siteSource.select("div")
            
            for item in elements {
                print("item:[\(item)]")
                print("item.className: {\(try item.className())}")
            }
            
            print("by select: \(try siteSource.select("div").array().count)")
            print("by body: \(try siteSource.body()?.getElementsByClass("tariff").array().count)")

        } catch let error {
            print("Error: \(error)")
        }

        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let myHTMLString = try String(contentsOf: myURL)
            //print("HTML : \(myHTMLString)")
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    func getWebView() -> WKWebView {
        return webView
    }
    
    func getWebData() {//}-> [()] {
        var flight: Flight = .init(flightIndex: "S7 182",
                                   aiportSource: "OBV",
                                   airportDest: "DME",
                                   departureTime: "05:50",
                                   landingTime: "06:10",
                                   price: "42000")
        //flight.sendDataToRealm()
        flight.createBase()
        flight.saveToBase()
        flight.loadFromBase()
        //flight.clearDataBase()
        //flight.getFromBaseByFlightName(flightName: "S7 182", array: &<#[(aiportSource: String, airportDest: String, departureTime: String, landingTime: String, price: String)]#>)

    }
    
}


