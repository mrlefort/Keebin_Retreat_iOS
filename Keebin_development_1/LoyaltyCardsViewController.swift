//
//  LoyaltyCardsViewController.swift
//  Keebin_development_1
//
//  Created by Steffen Lefort on 03/02/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit

//hvordan hver cell ser ud
struct cellData{
    let cell : Int!
    let image1 : UIImage!
    let infoString : String!
    let timesUsed: Int!
    let maxCoffeesNeededForCell: Int!
    let numberOfBeansForInfoStringForCell: Int!
    let numberOfCoffeesAvailable: Int!
    let loyaltyCardId: Int!
}

var coffeeBrandsFromDB = [AnyObject]()

var freeCoffee: Int?

class LoyaltyCardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  	
    
    // outlets

    @IBOutlet weak var loyaltyCardsTable: UITableView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // variables
    var arrayOfCellData = [cellData]()
    var tokens =  [String: String]()
    var json:[[String:Any]] = []
    var tag: Int!
    
    var clickCard: Bool = false;
    var clickFAB: Bool = false;
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(clickCard)
        {
            let dest = segue.destination as! loyaltyCardSelectedViewController
            dest.data = arrayOfCellData[tag]
        }
    }
    
    func noLoyaltyCardsAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func infoAlert(message: String, title: String = "", freeCoffees: Int) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {action in self.goToLoyal(freeC: freeCoffees)})
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //sender brugeren videre til loyaltyCardSelectedViewController hvis de har nogle kopper kaffe at redeem.
    func goToLoyal(freeC: Int)
    {
        if(freeC >= 1){
            self.performSegue(withIdentifier: "showSelectedLoyaltyCard", sender: self)
        }
    }
    
   
    
    
    func getLoyaltyCardsFromServer(callback: @escaping (_ loyaltyCardsloaded: Bool) -> ()){
        getTokensFromDB(){ dbTokens in
            self.tokens = dbTokens
        }
        
        let urlPath = "\(baseApiUrl)/users/allcards/"
        let url = NSURL(string: urlPath)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue(tokens["accessToken"]!, forHTTPHeaderField: "accessToken")
        request.addValue(tokens["refreshToken"]!, forHTTPHeaderField: "refreshToken")
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("response code is: \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 200){
                    let aToken = httpResponse.allHeaderFields["accessToken"] as? String
                    updateAccessTokenOnly(newAccessToken: aToken!)
                    if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                        self.json = jsonResponse!
                        callback(true)
                    }
                } else {
                    callback(false)
                }
            }
        })
        task.resume()
    }
    
    
    override func viewDidLoad() {
        getCoffeeBrandsFromDB(){ dbCoffeeBrands in
            coffeeBrandsFromDB = dbCoffeeBrands
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        clickCard = false;
        self.arrayOfCellData.removeAll()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        getLoyaltyCardsFromServer(){loyaltyCardsloaded in
            getBrandImageFromDB(){brandImagesFromDB in
            
            
            if (loyaltyCardsloaded){
                if self.json.count > 0 {
                    for each in self.json {
                        var brandNameForIString: String = ""
                        var maxCoffeesNeeded: Int?
                        var logoImageForLoyaltyCard: UIImage?
                        for i in coffeeBrandsFromDB {
                            if (each["brandName"]! as! Int == i.value(forKey: "dataBaseId")! as! Int){
                                brandNameForIString = i.value(forKey: "brandName") as! String
                                maxCoffeesNeeded = i.value(forKey: "numberOfCoffeesNeeded") as? Int
                                for each2 in brandImagesFromDB{
                                    if (brandNameForIString == each2.key){
                                    logoImageForLoyaltyCard = each2.value
                                    }
                                }
                            }
                        }
                        let cardId: Int = each["id"]! as! Int
                        freeCoffee = each["numberOfFreeCoffeeAvailable"]! as? Int
                        let numberOfBeansForInfoString: Int = each["numberOfCoffeesBought"]! as! Int
                        var kopOrKopper: String = ""
                        var kopOrKopper2: String = ""
                        if (numberOfBeansForInfoString == 1){
                            kopOrKopper = "kop"
                        } else {
                            kopOrKopper = "kopper"
                        }
                        if (freeCoffee! == 1){
                            kopOrKopper2 = "kop"
                        } else {
                            kopOrKopper2 = "kopper"
                        }
                        let timesUsed = each["timesUsed"]! as! Int
                        let coffeesMissing: Int?
                        let iString: String?

                        if (freeCoffee! < 1){
                            coffeesMissing = maxCoffeesNeeded! - numberOfBeansForInfoString
                            iString = "Dette er dit loyalitetskort til \(brandNameForIString). Du har købt \(numberOfBeansForInfoString) \(kopOrKopper) og mangler at købe \(coffeesMissing!) for at få en gratis kop kaffe!"
                        } else {
                            // showSelectedLoyaltyCard
                            coffeesMissing = 0
                            iString = "Dette er dit loyalitetskort til \(brandNameForIString). Du har købt \(numberOfBeansForInfoString) \(kopOrKopper) og har \(freeCoffee!) gratis \(kopOrKopper2) kaffe til rådighed!"
                            

                        }
                        
                        //Her sætter vi data ind i hver cell i arrayOfCellData
                        self.arrayOfCellData.append(cellData(cell : 1, image1 : logoImageForLoyaltyCard, infoString : iString, timesUsed: timesUsed, maxCoffeesNeededForCell: maxCoffeesNeeded, numberOfBeansForInfoStringForCell: numberOfBeansForInfoString, numberOfCoffeesAvailable: freeCoffee!, loyaltyCardId: cardId))
                    }
                    self.arrayOfCellData.sort(){ $0.timesUsed > $1.timesUsed }
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.loyaltyCardsTable.reloadData()
                    }
                } else {
                    self.noLoyaltyCardsAlert(message: "Du har endnu ikke nogen loyalitetskort. Køb en kop kaffe hos en af caféerne du finder på home siden for at komme i gang.")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
            else {
                self.noLoyaltyCardsAlert(message: "Der opstod en fejl ved forbindelse til serveren. Bekræft denne enhed har adgang til internettet.")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    //Bliver kørt når man trykker på et loyaltyCard
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //hvis man har gratis kopper kaffe at indløse bliver clickcard sat til true (prepare segue bliver kørt)
        if (self.arrayOfCellData[indexPath.row].numberOfCoffeesAvailable! >= 1){
            clickCard = true;
        }
        DispatchQueue.main.async {
            self.infoAlert(message: self.arrayOfCellData[indexPath.row].infoString, freeCoffees: self.arrayOfCellData[indexPath.row].numberOfCoffeesAvailable!)
            self.tag = indexPath.row
        }
    }
    
    //Her fylder vi billeder og data i cellerne i tableview.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCellData[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("LoyaltyCardsViewCell", owner: self, options: nil)?.first as! LoyaltyCardsViewCell
            cell.logoImage.image = arrayOfCellData[indexPath.row].image1
            let maxCoffeesNeeded = arrayOfCellData[indexPath.row].maxCoffeesNeededForCell!
            let numberOfBeansForInfoString = arrayOfCellData[indexPath.row].numberOfBeansForInfoStringForCell!
            let numberOfCoffeesAvailable = arrayOfCellData[indexPath.row].numberOfCoffeesAvailable!
            let freeCoffeeString: String = "x \(numberOfCoffeesAvailable)"
            
            
            if (maxCoffeesNeeded >= 1){
                if (numberOfBeansForInfoString >= 1){
                    cell.bean1.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean1.image = #imageLiteral(resourceName: "emptyBean")
                }
            }
            if (maxCoffeesNeeded >= 2){
                if (numberOfBeansForInfoString >= 2){
                    cell.bean2.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean2.image = #imageLiteral(resourceName: "emptyBean")
                }
            }
            if (maxCoffeesNeeded >= 3){
                if (numberOfBeansForInfoString >= 3){
                    cell.bean3.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean3.image = #imageLiteral(resourceName: "emptyBean")
                }
                
            }
            if (maxCoffeesNeeded >= 4){
                if (numberOfBeansForInfoString >= 4){
                    cell.bean4.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean4.image = #imageLiteral(resourceName: "emptyBean")
                }
                
            }
            if (maxCoffeesNeeded >= 5){
                if (numberOfBeansForInfoString >= 5){
                    cell.bean5.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean5.image = #imageLiteral(resourceName: "emptyBean")
                }
                
            }
            if (maxCoffeesNeeded >= 6){
                if (numberOfBeansForInfoString >= 6){
                    cell.bean6.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean6.image = #imageLiteral(resourceName: "emptyBean")
                }
                
            }
            if (maxCoffeesNeeded >= 7){
                if (numberOfBeansForInfoString >= 7){
                    cell.bean7.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean7.image = #imageLiteral(resourceName: "emptyBean")
                }
                
            }
            if (maxCoffeesNeeded >= 8){
                if (numberOfBeansForInfoString >= 8){
                    cell.bean8.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean8.image = #imageLiteral(resourceName: "emptyBean")
                }
                
            }
            if (maxCoffeesNeeded >= 9){
                if (numberOfBeansForInfoString >= 9){
                    cell.bean9.image = #imageLiteral(resourceName: "fullBean")
                } else {
                    cell.bean9.image = #imageLiteral(resourceName: "emptyBean")
                }
                
            }
            if (numberOfCoffeesAvailable >= 1){
                cell.coffee.image = #imageLiteral(resourceName: "fullCoffee")
                if(numberOfCoffeesAvailable >= 2){
                    cell.freeCoffeeLabel.text = freeCoffeeString
                }
            } else {
                cell.coffee.image = #imageLiteral(resourceName: "emptyCoffee")
            }
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("LoyaltyCardsViewCell", owner: self, options: nil)?.first as! LoyaltyCardsViewCell
            cell.logoImage.image = arrayOfCellData[indexPath.row].image1
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].cell == 1 {
            return 140
        } else {
            return 140
        }
    }
}
