//
//  DestinationData.swift
//  Keebin_development_1
//
//  Created by sr on 07/05/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import Foundation

public class Menu {
    
    public var name: String
    public var image: UIImage
    public var menuItems: [Items]?
    public var id: Int?
    
    init(name: String, image: UIImage, menuItems: [Items]?) {
        self.name = name
        self.image = image
        self.menuItems = menuItems

    }
}

public class Items {
    public var name: String
    public var price: Int
    public var count: Int
    public var id: Int?
    
    init(name: String, price: Int, count: Int) {
        self.name = name
        self.price = price
        self.count = count
    }
}
