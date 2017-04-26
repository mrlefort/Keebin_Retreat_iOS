//
//  loyaltyCardSelectedViewController.swift
//  Keebin_development_1
//
//  Created by sr on 15/03/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit

class loyaltyCardSelectedViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //cellData fra cell'en man har trykket på.
    var data: cellData!
    // mangler at vise en loader når man prøver at bruge sit kort så du kan se den tænker.
    
//    var cellData: cellDataKlippeKort!

    @IBOutlet weak var err: UILabel!
    var tokens = [[]]
    
    var clip = "1";
    //Array med antal klip til rådighed.
    var clipArray: [String] = []
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.layer.cornerRadius = 10;
        slider.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        activityIndicator.hidesWhenStopped = true

        let uses = data.numberOfCoffeesAvailable!
        if(uses > 0)
        {
            err.text = "";
            
            //uses er antal klip man har. For loop herunder append'er 1,2,3 etc ind i cliparray for hvert antal klip.
            for a in 1...uses
            {
                clipArray.append("\(a)")
            }
            
            slider.addTarget(self, action: #selector(KlippekortSelectedViewController.sliderDidEndSliding(_:)), for: .touchUpInside)
        }
    }
    
    
    //Har man ingen kopper kaffe til rådighed bliver man sendt tilbage.
    func redeemAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {action in self.sendBackToPreviousSegue()})
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Slider - når den er "swiped" helt til højre
    func sliderDidEndSliding(_ sender: Any) {
        if(slider.value == 30.0) {
            activityIndicator.startAnimating()
            self.useCard()
                {b in
                    if(b)
                    {
                        self.redeemAlert(message: "Du har nu brugt \(self.clip) kop kaffe.")
//                        self.sendBackToPreviousSegue()
                    }
                    else
                    {
                        self.err.text = "Brugen af loyalitetskortet gik ikke igennem. Prøv igen senere."
                    }
            }
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.slider.value = 0;
                    
            }
            )
        }
    }
    
    //Api kald til redeem loyaltyCard
    func useCard(callback: @escaping (_ abe: Bool)-> ()){
        getTokensFromDB(){ dbTokens in
            let accessToken = dbTokens["accessToken"]!
            let refreshToken = dbTokens["refreshToken"]!
    
            let urlPath = "\(baseApiUrl)/users/cardRedeem/\(self.data.loyaltyCardId!))"
            let url = NSURL(string: urlPath)
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url as! URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(accessToken, forHTTPHeaderField: "accessToken")
            request.addValue(refreshToken, forHTTPHeaderField: "refreshToken")
            request.httpMethod = "PUT"
            
            let jsonObject: [String: Any] = [
                "userId" : LoginViewController.user.id!,
                "numberOfCoffeeRedeems": self.clip,
            ]
            var cb = false;
            print(jsonObject)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                
                request.httpBody = jsonData
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    
                    let httpResponse = response as? HTTPURLResponse;
                    
                    if(httpResponse != nil)
                    {
                        
                        if(httpResponse!.statusCode == 200)
                        {
                            cb = true
                        }
                        else
                        {
                            cb = false;
                            
                        }
                    }
                    else
                    {
                        cb = false;
                        
                    }
                    callback(cb)
                })
                task.resume()
                
                
            } catch {
                
                callback(cb)
            }
        }
    }
    
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clipArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clipArray[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        clip = clipArray[row];
    }
    
    override func accessibilityElementDidLoseFocus() {
        
    }
    
    
    //sender brugeren tilbage til forrige segue.
    func sendBackToPreviousSegue(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
  
    
    
}
