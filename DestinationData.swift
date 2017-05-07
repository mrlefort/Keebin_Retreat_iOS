//
//  DestinationData.swift
//  Keebin_development_1
//
//  Created by sr on 07/05/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import Foundation

public class DestinationData {
    
    public var name: String
    public var price: String
    public var imageName: String
    public var flights: [FlightData]?
    
    init(name: String, price: String, imageName: String, flights: [FlightData]?) {
        self.name = name
        self.price = price
        self.imageName = imageName
        self.flights = flights
    }
}

public class FlightData {
    public var start: String
    public var end: String
    
    init(start: String, end: String) {
        self.start = start
        self.end = end
    }
}
