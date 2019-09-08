//
//  Flight.swift
//  flights
//
//  Created by Aleksandr Gusev on 08/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import RealmSwift

class FlightObject: Object {
    @objc dynamic var flightIndex: String = ""
    @objc dynamic var aiportSource: String = ""
    @objc dynamic var airportDest: String = ""
    @objc dynamic var departureTime: String = ""
    @objc dynamic var landingTime: String = ""
    @objc dynamic var price: String = ""
    
}

class Flight {
    private var realm: Realm?
    
    //var id: Int64 = 0
    var flightIndex: String = ""
    var aiportSource: String = ""
    var airportDest: String = ""
    var departureTime: String = ""
    var landingTime: String = ""
    var price: String = ""
    
    init (flightIndex: String,
          aiportSource: String,
          airportDest: String,
          departureTime: String,
          landingTime: String,
          price: String) {
        self.flightIndex = flightIndex
        self.aiportSource = aiportSource
        self.airportDest = airportDest
        self.departureTime = departureTime
        self.landingTime = landingTime
        self.price = price
    }
    init () {
        
    }
    
    func createBase() {
        do {
            realm = try! Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        } catch let error {
            print("Realm error: \(error)")
        }
    }
    
    func makeFlightbyName() -> FlightObject {
        let newFlight = FlightObject()
        newFlight.flightIndex = flightIndex
        newFlight.aiportSource = aiportSource
        newFlight.airportDest = airportDest
        newFlight.departureTime = departureTime
        newFlight.landingTime = landingTime
        newFlight.price = price
        
        return newFlight
    }
    
    func saveToBase() {
        if realm != nil {
            try! realm?.write {
                realm?.add(makeFlightbyName())
            }
        }
    }
    
    func loadFromBase() {
        if realm != nil {
            let result = realm?.objects(FlightObject.self)
            print("result: \(result![0].departureTime)")
        }
    }
    
    func getFromBaseByFlightName(flightName: String, array: inout [(aiportSource:String,
                                                                    airportDest:String,
                                                                    departureTime:String,
                                                                    landingTime:String,
                                                                    price:String)]) {
        if realm != nil {
            let result = realm?.objects(FlightObject.self)
            for item in result! {
                if flightName == item.flightIndex {
                    print("object found \(item.airportDest)")
                    array.append((item.aiportSource,
                                  item.airportDest,
                                  item.departureTime,
                                  item.landingTime,
                                  item.price))
                }
            }
        } else {
            print("rea;m object is nil")
        }
    }
    
    func setObjectsFilter() {
        
    }
    
    func getRealmObjectsCount() {
        // if object == filter. To get only correct rows
    }
    
    func clearDataBase() {
        if realm != nil {
            realm?.deleteAll()
        }
    }
    
}
