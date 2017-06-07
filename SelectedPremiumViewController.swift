//
//  SelectedPremiumViewController.swift
//  Keebin_development_1
//
//  Created by Steffen Lefort on 09/05/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit

class SelectedPremiumViewController: UIViewController {

    @IBOutlet weak var premiumInfoTextBox: UILabel!
    @IBOutlet weak var premiumPris: UILabel!
    @IBOutlet weak var whiteBackground: UILabel!
    @IBOutlet weak var whiteBackground2: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tilmeldButton: UIButton!
    
    
    @IBAction func tilmeldButton(_ sender: Any) {
        activityIndicator.startAnimating()
        tilmeldButton.isEnabled = false
        subscribeToPremium()
    }


    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tilmeldButton.isEnabled = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.activityIndicator.color = UIColor.black
        activityIndicator.center.x = view.frame.width/2
        activityIndicator.center.y = view.frame.height/2.20
        self.activityIndicator.hidesWhenStopped = true
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        premiumInfoTextBox.text = "Premium er for dig som elsker kaffe. Ved at abonnere på Premium får du 1 kop gratis kaffe hver uge! Du går ned til en RetreatFood efter dit valg, bestiller en kop kaffe og viser din Premium side, samt giver baristaen dit brugerID. Så får du en kop kaffe, uden at skulle betale for den."
        premiumPris.text = "Premium koster kun 75kr om måneden."
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func subscribeToPremium(callback: @escaping (_ abe: Bool)-> ()){
    func subscribeToPremium(){
        
        getTokensFromDB(){ dbTokens in
            
            let accessToken = dbTokens["accessToken"]!
            let refreshToken = dbTokens["refreshToken"]!
            let urlPath = "\(baseApiUrl)/users/createPremiumSubscription"
            let url = NSURL(string: urlPath)
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url! as URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(accessToken, forHTTPHeaderField: "accessToken")
            request.addValue(refreshToken, forHTTPHeaderField: "refreshToken")

            request.httpMethod = "POST"
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("response code is: \(httpResponse.statusCode)")
                    if (httpResponse.statusCode == 200){
                        //send brugeren besked om at han er subscribed
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.alert(message: "Tillykke! Du er nu Premium Kunde. Du kan altid afmelde dit medlemsskab under indstillinger.")
                        }
                        
                        
                        //                    callback(true)
                    } else if (httpResponse.statusCode == 757){
                        //giv brugeren besked på at han mangler at tilføje et card
                        self.activityIndicator.stopAnimating()
                        self.alert(message: "Du skal tilføje et kort til din profil før du kan tilmelde dig Premium. Dette kan du gøre under indstillinger.")
                    } else {
                        //fortæl brugeren han skal prøve igen senere
                        self.activityIndicator.stopAnimating()
                        self.alert(message: "Der skete en fejl. Prøv venligst igen senere.")
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    self.alert(message: "Der skete en fejl. Prøv venligst igen senere.")
                    //                callback(false)
                }
            })
            task.resume()
        }
        
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
