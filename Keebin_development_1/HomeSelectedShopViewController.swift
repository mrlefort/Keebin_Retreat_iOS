//
//  HomeSelectedShopViewController.swift
//  Keebin_development_1
//
//  Created by sr on 08/02/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit

class HomeSelectedShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {


    @IBAction func checkOut(_ sender: Any) {
    }
    @IBOutlet weak var totalProducts: UILabel!

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var totalCost: UILabel!
    var destinationData: [Menu?]?
    
    var basket = [Items]()
    var expanded: Int!
    var expandedbool = false;
 
    
    override func viewDidLoad() {
        destinationData = getData()
        
//        self.automaticallyAdjustsScrollViewInsets = false;
//        tableView.estimatedRowHeight = 142;
//        self.tableView.setNeedsLayout()
//        self.tableView.layoutIfNeeded()
//        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    private func getData() -> [Menu?] {
        let data: [Menu?] = []
        
        let arrayOfSandwiches = [Items(name: "Ham & cheese", price: 65, count: 0), Items(name: "Chicken, bacon & curry", price: 69, count: 0), Items(name: "Ham, cheese & bacon", price: 75, count: 0)]
        let menuSandwiches = Menu(name: "Sandwiches", image: #imageLiteral(resourceName: "riccos_1"), menuItems: arrayOfSandwiches)
        
        let arrayOfDrinks = [Items(name: "Espresso", price: 45, count: 0), Items(name: "Moka", price: 59, count: 0), Items(name: "Frappé", price: 55, count: 0)]
        let menuDrinks = Menu(name: "Drinks", image: #imageLiteral(resourceName: "fullCoffee"), menuItems: arrayOfDrinks)
        
        return [menuDrinks, menuSandwiches]
    }
    
    /*  Number of Rows  */
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = destinationData {
            return data.count
        } else {
            return 0
        }
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("when is this run 6")
        if let rowData = destinationData?[indexPath.row] {
            return 80
        } else {
            return 70
        }
    }
    
    /*  Create Cells    */
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Row is DefaultCell
        print("Hvad sker der her?")
        
        if let rowData = destinationData?[indexPath.row] {
            let defaultCell = Bundle.main.loadNibNamed("TableViewCellMenuItems", owner: self, options: nil)?.first as! TableViewCellMenuItems
            
//            tableView.dequeueReusableCell(withIdentifier: "TableViewCellMenuItems", for: indexPath).first as! TableViewCellMenuItems
            defaultCell.menuName.text = rowData.name
            defaultCell.menuPicture.image = rowData.image
      defaultCell.menuFoldPic.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down")
            
            defaultCell.selectionStyle = .none
            return defaultCell
        }
            // Row is ExpansionCell
        else {
            if let rowData = destinationData?[getParentCellIndex(expansionIndex: indexPath.row)] {
            print("her åbner vi")
        
                
//                //  Create an ExpansionCell
                let expansionCell =
                Bundle.main.loadNibNamed("TableViewCellMenuItemExpanded", owner: self, options: nil)?.first as! TableViewCellMenuItemExpanded
                
                //  Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
            
                
                //  Get the index of the flight data (e.g. if there are multiple ExpansionCells
                let flightIndex = indexPath.row - parentCellIndex - 1
                
                //  Set the cell's data
                expansionCell.itemPrice.text = String (describing: "\(rowData.menuItems![flightIndex].price) kr")
                expansionCell.itemName.text = rowData.menuItems?[flightIndex].name
                expansionCell.itemCount.text = String (describing: rowData.menuItems![flightIndex].count)
//                expansionCell.itemCount.text = String (describing: indexPath.row)
                expansionCell.itemAdd.tag = Int(indexPath.row)
                expansionCell.itemMinus.tag = Int(indexPath.row)
                
                
                expansionCell.itemAdd.addTarget(self, action: #selector(HomeSelectedShopViewController.plus(_:)), for: .touchUpInside)
                
                
                 expansionCell.itemMinus.addTarget(self, action: #selector(HomeSelectedShopViewController.minus(_:)), for: .touchUpInside)
                
                expansionCell.selectionStyle = .none
                return expansionCell
            }
        }
        return UITableViewCell()
    }
    
    func plus(_ sender: AnyObject?) {
        
     
        
 if let rowData = destinationData?[getParentCellIndex(expansionIndex: sender!.tag)] {
    //  Get the index of the parent Cell (containing the data)
    let parentCellIndex = getParentCellIndex(expansionIndex: sender!.tag)
    
    
    //  Get the index of the flight data (e.g. if there are multiple ExpansionCells
    let flightIndex = sender!.tag - parentCellIndex - 1
    print("her er selected index: \(flightIndex)")
  
//    print(flightIndex)
//  print(rowData.menuItems!.count)
    
    let data = rowData.menuItems![flightIndex]
 
    let item = Items(name: data.name, price: data.price, count: data.count)

    
    var counter = 0;
    for x in self.basket {
        
        if(x.name == item.name || x.price == item.price)
        {
       counter = counter+1;
        }
        
    }
    
    if(counter >= 99)
    {
        
    }
    else
    {
    DispatchQueue.main.async {

        // er nået til at skulle kigge på om hvordan man opdatere labellen ved siden af plus knappen når du trykker på den. tænker man kan finde en måde at opdatere den automatisk eller lign?
        
          self.basket.append(item)
        
        self.updateBasket()
        rowData.menuItems![flightIndex].count = rowData.menuItems![flightIndex].count+1;
        self.table.reloadData()
        
    }
    }
  
    
 
   
        }
        
    }
    
    func updateBasket()
    {
        var totalprice = 0
        var totalAmountOfitems = 0;
        self.basket.forEach({ (x) in
           totalprice += x.price
            totalAmountOfitems += 1
        })
        self.totalProducts.text = "\(totalAmountOfitems) varer"
        self.totalCost.text = "\(totalprice).- dkk"
    }
    
    func minus(_ sender: AnyObject?) {
    
        if let rowData = destinationData?[getParentCellIndex(expansionIndex: sender!.tag)] {
            //  Get the index of the parent Cell (containing the data)
            let parentCellIndex = getParentCellIndex(expansionIndex: sender!.tag)
            
            
            //  Get the index of the flight data (e.g. if there are multiple ExpansionCells
            let flightIndex = sender!.tag - parentCellIndex - 1
            
            let data = rowData.menuItems![flightIndex]
            
            let item = Items(name: data.name, price: data.price, count: data.count)
            
            DispatchQueue.main.async {
                
                // er nået til at skulle kigge på om hvordan man opdatere labellen ved siden af plus knappen når du trykker på den. tænker man kan finde en måde at opdatere den automatisk eller lign?
                
                var counter = 0;
                for x in self.basket {
                  
                    if(x.name == item.name || x.price == item.price)
                    {
                        if(item.count == 0)
                        {
                           break 
                        }
                        else
                        {
                            self.basket.remove(at: counter)
                            self.updateBasket()
                            rowData.menuItems![flightIndex].count = rowData.menuItems![flightIndex].count-1;
                            self.table.reloadData()

                            break
                        }
               
                    }
                      counter = counter+1;
                }
 
             
                
             
                
            }
 }
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("when is this run 3")
        if let data = destinationData?[indexPath.row] {
            
            // If user clicked last cell, do not try to access cell+1 (out of range)
            if(indexPath.row + 1 >= (destinationData?.count)!) {
//                if(expandedbool)
//                {
//                    print("luk nu")
//                    contractCell(tableView: tableView, index: expanded)
//                }
//                print("i if!!")
//                expandedbool = true
//                expanded = indexPath.row
//                print("expanded: \(expanded)")

                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                // If next cell is not nil, then cell is not expanded
                if(destinationData?[indexPath.row+1] != nil) {
                    // Close Cell (remove ExpansionCells)
//                    
//                    print("i else 2!")
//                    if(expandedbool)
//                    {
//                        print("den her kørt?")
//                        contractCell(tableView: tableView, index: indexPath.row)
//                    }
//                    expandedbool = true
//                    expanded = indexPath.row
//                    print("expanded2: \(expanded)")
                    expandCell(tableView: tableView, index: indexPath.row)
                   
                    
                    
                } else {
                    
                    contractCell(tableView: tableView, index: indexPath.row)
                    
                }
            }
        }
    }
    
    /*  Expand cell at given index  */
    private func expandCell(tableView: UITableView, index: Int) {
//        print("when is this run 1")
        // Expand Cell (add ExpansionCells
        if let flights = destinationData?[index]?.menuItems {
            for i in 1...flights.count {
                destinationData?.insert(nil, at: index + i)
                tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    /*  Contract cell at given index    */
    private func contractCell(tableView: UITableView, index: Int) {
//        print("when is this run 4")
        if let flights = destinationData?[index]?.menuItems {
            for i in 1...flights.count {
                destinationData?.remove(at: index+1)
                tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
                
            }
        }
    }
    
    /*  Get parent cell index for selected ExpansionCell  */
    private func getParentCellIndex(expansionIndex: Int) -> Int {
//        print("when is this run 5")
        var selectedCell: Menu?
        var selectedCellIndex = expansionIndex
        
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = destinationData?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
}

