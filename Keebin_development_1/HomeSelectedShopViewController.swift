//
//  HomeSelectedShopViewController.swift
//  Keebin_development_1
//
//  Created by sr on 08/02/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit

class HomeSelectedShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {



    var destinationData: [Menu?]?
    
    override func viewDidLoad() {
        destinationData = getData()
        
        //self.automaticallyAdjustsScrollViewInsets = false;
        //tableView.estimatedRowHeight = 142;
        //self.tableView.setNeedsLayout()
        //self.tableView.layoutIfNeeded()
        //tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    private func getData() -> [Menu?] {
        let data: [Menu?] = []
        
        let sanFranciscoFlights = [Items(start: "MAN", end: "CFO")]
        let sanFrancisco = Menu(name: "San Francisco", price: "£425", imageName: "san_francisco-banner", flights: sanFranciscoFlights)
        
        let londonFlights = [Items(start: "MAN", end: "LHR"), Items(start: "MAN", end: "LCY")]
        let london = Menu(name: "London", price: "£500", imageName: "london-banner", flights: londonFlights)
        
        let newYorkFlights = [Items(start: "MAN", end: "JFK")]
        let newYork = Menu(name: "New York", price: "£630", imageName: "new_york-banner", flights: newYorkFlights)
        
        return [sanFrancisco, london, newYork]
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
        if let rowData = destinationData?[indexPath.row] {
            return 60
        } else {
//           let flights = destinationData?[indexPath.row]?.flights
//           // kigger videre på det her shit i dag.
//            print("her er count")
//            var total = flights?.count
//            print(total!)
            var total = 0;
            if let flights = destinationData?[indexPath.row]?.flights {
                for i in 0...flights.count {
                    print(flights.count)
                    total = total + 1;
                    
                }
            }
            
            return CGFloat(total*30)
        }
    }
    
    /*  Create Cells    */
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Row is DefaultCell
        if let rowData = destinationData?[indexPath.row] {
            let defaultCell = Bundle.main.loadNibNamed("TableViewCellMenuItems", owner: self, options: nil)?.first as! TableViewCellMenuItems
            
//            tableView.dequeueReusableCell(withIdentifier: "TableViewCellMenuItems", for: indexPath).first as! TableViewCellMenuItems
            defaultCell.menuName.text = rowData.name
            defaultCell.menuPicture.image = #imageLiteral(resourceName: "ic_my_location")
      defaultCell.menuFoldPic.image = #imageLiteral(resourceName: "ic_my_location")
            
            defaultCell.selectionStyle = .none
            return defaultCell
        }
            // Row is ExpansionCell
        else {
            if let rowData = destinationData?[getParentCellIndex(expansionIndex: indexPath.row)] {
//                //  Create an ExpansionCell
                let expansionCell =
//                    
//                    tableView.dequeueReusableCell(withIdentifier: "TableViewCellMenuItemExpanded", for: indexPath) as! TableViewCellMenuItemExpanded

                
                Bundle.main.loadNibNamed("TableViewCellMenuItemExpanded", owner: self, options: nil)?.first as! TableViewCellMenuItemExpanded
                
                //  Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                
                //  Get the index of the flight data (e.g. if there are multiple ExpansionCells
                let flightIndex = indexPath.row - parentCellIndex - 1
                
                //  Set the cell's data
                expansionCell.itemPrice.text = rowData.flights?[flightIndex].start
                expansionCell.itemName.text = rowData.flights?[flightIndex].end
                expansionCell.selectionStyle = .none
                return expansionCell
            }
        }
        return UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = destinationData?[indexPath.row] {
            
            // If user clicked last cell, do not try to access cell+1 (out of range)
            if(indexPath.row + 1 >= (destinationData?.count)!) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                // If next cell is not nil, then cell is not expanded
                if(destinationData?[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                    // Close Cell (remove ExpansionCells)
                } else {
                    contractCell(tableView: tableView, index: indexPath.row)
                    
                }
            }
        }
    }
    
    /*  Expand cell at given index  */
    private func expandCell(tableView: UITableView, index: Int) {
        // Expand Cell (add ExpansionCells
        if let flights = destinationData?[index]?.flights {
            for i in 1...flights.count {
                destinationData?.insert(nil, at: index + i)
                tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    /*  Contract cell at given index    */
    private func contractCell(tableView: UITableView, index: Int) {
        if let flights = destinationData?[index]?.flights {
            for i in 1...flights.count {
                destinationData?.remove(at: index+1)
                tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
                
            }
        }
    }
    
    /*  Get parent cell index for selected ExpansionCell  */
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: Menu?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = destinationData?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
}

//    struct cellDataItem{
//        let itemName : String!
//        let count : Int!
//        let Price : Int!
//    }
//    
//    struct Menus{
//        let menuName : String!
//        let menuPic : UIImage!
//        let arrayOfCellDataItems : [cellDataItem]?
//    }
//
//
//    
////    var shops = Array<(CoffeeShop)>()
////    var shop = CoffeeShop()
////    var brandName = "";
////    var pictureUrl:UIImage?;
//    var arrayOfCellMenus = Array<(Menus)>()
//    var arrayOfCellItem = Array<(cellDataItem)>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        var item1 = cellDataItem(itemName: "Genji", count: 0, Price: 375)
//        var item2 = cellDataItem(itemName: "Hanzo", count: 0, Price: 65)
//        
//        arrayOfCellItem.append(item1)
//        arrayOfCellItem.append(item2)
//        
//        var menu1 = Menus(menuName: "Overwatch Heroes", menuPic: #imageLiteral(resourceName: "Maps"), arrayOfCellDataItems: arrayOfCellItem)
//        
//        arrayOfCellMenus.append(menu1)
//
//        tabBarController?.tabBar.isHidden = true
//        self.navigationController?.navigationBar.tintColor = UIColor.white;
//        
//
//        print(arrayOfCellMenus.count)
// 
//        
//        
////        picture.setImage(pictureUrl, for: UIControlState.normal)
//        
//    }
//    
//    
//    func tableView( _ myTable: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return arrayOfCellMenus.count;
//
//    }
//    
//    
//    func tableView( _ myTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("TableViewCellMenuItems", owner: self, options: nil)?.first as! TableViewCellMenuItems
//        
//        cell.menuName.text = arrayOfCellMenus[indexPath.row].menuName
//        cell.menuPicture.image = arrayOfCellMenus[indexPath.row].menuPic
//        cell.menuFoldPic.image = #imageLiteral(resourceName: "ic_my_location")
//        
//        
////        cell.menuName.text = ""
////        cell.menuPicture.image = #imageLiteral(resourceName: "ic_loyalty")
////        cell.menuPlusPicture.image = #imageLiteral(resourceName: "ic_my_location")
//        
//        return cell
//    }
//
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}
