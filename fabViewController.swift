//
//  fabViewController.swift
//  Keebin_development_1
//
//  Created by sr on 23/02/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit

class fabViewController: UIViewController {
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var err: UILabel!
    @IBOutlet weak var CoffeeCode: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    var errors: Bool = false;
    var errmsg: String = "";
    
    @IBOutlet weak var btn_buycard: UIButton!
    
    @IBOutlet weak var btn_buyCoffee: UIButton!
    
    
    
    
    func alertFAB(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: goBack)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goBack(lol: UIAlertAction)
    {
        DispatchQueue.main.async {
            //            self.activityIndicator.stopAnimating()
            _ = self.navigationController?.popViewController(animated: true)
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_buycard.layer.cornerRadius = 10;
        btn_buycard.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn_buyCoffee.layer.cornerRadius = 10;
        btn_buyCoffee.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func addCoffee(_ sender: Any) {
        errors = false;
        errmsg = "";
        err.text = "";
        
        if(CoffeeCode.text!.isEmpty)
        {
            errors = true;
            errmsg += "Kaffe koden må ikke være tom \n"
        }
        if(amount.text!.isEmpty)
        {
            errors = true;
            
            errmsg += "antal må ikke være tom og skal må kun være tal. \n"
            
        }
        else
        {
            if(!isOnlyInts(testStr: amount.text!))
            {
                errors = true;
                
                errmsg += "antal må ikke være tom og skal være tal. \n"
            }
        }
        
        if(!errors)
        {
            DispatchQueue.main.async {
                self.loading.startAnimating();
            }
            addToCard(userId: LoginViewController.user.id!)
            {a in
                DispatchQueue.main.async {
                    self.loading.stopAnimating();
                }
                if(a)
                {
                    
                }
            }
        }
        else{
            
            err.text = errmsg;
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func addToCard(userId: Int, callback: @escaping (_ abe: Bool)-> ()) {
        
        getTokensFromDB(){ dbTokens in
            
            let accessToken = dbTokens["accessToken"]!
            let refreshToken = dbTokens["refreshToken"]!
            
            let urlPath = "\(baseApiUrl)/users/card/coffeeBought"
            let url = NSURL(string: urlPath)
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url as! URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(accessToken, forHTTPHeaderField: "accessToken")
            request.addValue(refreshToken, forHTTPHeaderField: "refreshToken")
            request.httpMethod = "POST"
            
            let jsonObject: [String: Any] = [
                "userId": userId,
                "numberOfCoffeesBought": self.amount.text!,
                "coffeeCode" : self.CoffeeCode.text!
            ]
            
            do {
                
                
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                request.httpBody = jsonData
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    
                    if((data) != nil)
                    {
                        
                        let httpResponse = response as? HTTPURLResponse;
                        
                        if(httpResponse!.statusCode == 200)
                        {
                            DispatchQueue.main.async {
                                
//                                self.err.text = "Tilføjet nye klip."
                                self.alertFAB(message: "Købet er gennemført og der er nu tilføjet nye klip til dit kort.", title: "Gennemført")
                                callback(true)
                            }
                        }
                        else
                        {
                            self.err.text = "noget gik galt.."
                            callback(false)
                            
                        }
                    }
                    else
                    {
                        self.err.text = "noget gik galt.."
                        callback(false)
                    }
                    
                })
                task.resume()
                
            }  catch {
                self.err.text = "noget gik galt.."
                callback(false)
            }
        }
    }
    
    
    func isOnlyInts(testStr:String) -> Bool {
        let IntRegEx = "^[0-9]*$"
        
        let intTest = NSPredicate(format:"SELF MATCHES %@", IntRegEx)
        return intTest.evaluate(with: testStr)
    }
    
}
