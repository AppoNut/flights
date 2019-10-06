//
//  Flight.swift
//  flights
//
//  Created by Aleksandr Gusev on 08/09/2019.
//  Copyright © 2019 aleksandr.gusev. All rights reserved.
//

import Foundation
import RealmSwift

// Model
class FlightObject: Object {
    @objc dynamic var flightIndex: String = ""
    @objc dynamic var aiportSource: String = ""
    @objc dynamic var airportDest: String = ""
    @objc dynamic var departureTime: String = ""
    @objc dynamic var landingTime: String = ""
    @objc dynamic var price: String = ""
    
}

// Class for managing database
class Flight {
    private var realm: Realm?
    
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
    
    init() {}
    
    func createBase() {
        realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func getBase() -> Realm {
        return realm!
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
    
    func loadFromBase(){
        if realm != nil {
            let result = realm?.objects(FlightObject.self)
        }
    }
    
    func getFromBaseByFlightName(flightName: String, array: inout [(aiportSource:String,
                                                                    airportDest:String,
                                                                    departureTime:String,
                                                                    landingTime:String,
                                                                    price:String)]) {
        let realm = try! Realm()
        if realm != nil {
            let result = realm.objects(FlightObject.self)
            for item in result {
                if flightName == item.flightIndex {
                    array.append((item.aiportSource,
                                  item.airportDest,
                                  item.departureTime,
                                  item.landingTime,
                                  item.price))
                }
            }
        }
    }
    
    func getAllFromBase(array: inout [(flightIndex:String,
                                       aiportSource:String,
                                       airportDest:String,
                                       departureTime:String,
                                       landingTime:String,
                                       price:String)]) {
        let realm = try! Realm()
        if realm != nil {
            let result = realm.objects(FlightObject.self)
            for item in result {
                array.append((item.flightIndex,
                              item.aiportSource,
                              item.airportDest,
                              item.departureTime,
                              item.landingTime,
                              item.price))
            }
        }
    }
    
    func isEnryExist(inputFlightId: String,
                     inputAiportSource: String,
                     inputAirportDest: String,
                     inputDepartureTime: String,
                     inputLandingTime: String,
                     inputPrice: String) -> Bool {
        let realm = try! Realm()
        if realm != nil {
            let result = realm.objects(FlightObject.self)
            for item in result {
                if item.flightIndex == inputFlightId &&
                   item.aiportSource == inputAiportSource &&
                   item.airportDest == inputAirportDest &&
                   item.departureTime == inputDepartureTime &&
                   item.landingTime == inputLandingTime &&
                   item.price == inputPrice {
                    return true
                }
            }
        }
        return false
    }

    func clearDataBase() {
        let realm = self.getBase()
        if realm != nil {
            realm.deleteAll()
        }
    }
    
}
