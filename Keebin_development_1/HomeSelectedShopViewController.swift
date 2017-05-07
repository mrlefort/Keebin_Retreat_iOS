//
//  HomeSelectedShopViewController.swift
//  Keebin_development_1
//
//  Created by sr on 08/02/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit

class HomeSelectedShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    struct cellDataItem{
        let itemName : String!
        let count : Int!
        let Price : Int!
    }
    
    struct Menus{
        let menuName : String!
        let menuPic : UIImage!
        let arrayOfCellDataItems : [cellDataItem]!
    }

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var shops = Array<(CoffeeShop)>()
    var shop = CoffeeShop()
    var brandName = "";
    var pictureUrl:UIImage?;
    var arrayOfCellMenus = Array<(Menus)>()
    var arrayOfCellItem = Array<(cellDataItem)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var item1 = cellDataItem(itemName: "Genji", count: 0, Price: 375)
        var item2 = cellDataItem(itemName: "Hanzo", count: 0, Price: 65)
        
        arrayOfCellItem.append(item1)
        arrayOfCellItem.append(item2)
        
        var menu1 = Menus(menuName: "Overwatch Heroes", menuPic: #imageLiteral(resourceName: "Maps"), arrayOfCellDataItems: arrayOfCellItem)
        
        arrayOfCellMenus.append(menu1)

        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        

        print(arrayOfCellMenus.count)
 
        
        
//        picture.setImage(pictureUrl, for: UIControlState.normal)
        
    }
    
    
    func tableView( _ myTable: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrayOfCellMenus.count;

    }
    
    
    func tableView( _ myTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCellForItems", owner: self, options: nil)?.first as! TableViewCellForItems
        
        cell.menuName.text = arrayOfCellMenus[indexPath.row].menuName
        cell.menuPicture.image = arrayOfCellMenus[indexPath.row].menuPic
        cell.menuPlusPicture.image = #imageLiteral(resourceName: "ic_my_location")
        
      
        
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
