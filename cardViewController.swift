//
//  cardViewController.swift
//  Keebin_development_1
//
//  Created by Steffen Lefort on 13/05/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit
import Stripe

class cardViewController: UIViewController{

    let cardParams = STPCardParams()


    @IBOutlet weak var createCardButton: UIButton!
    
    @IBAction func createCardButton(_ sender: Any) {
        createToken(cardParams: cardParams)
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCardButton.isEnabled = false
        let paymentField = STPPaymentCardTextField(frame: CGRect(x: 10, y: 10, width:300, height: 44))
        paymentField.delegate = self as? STPPaymentCardTextFieldDelegate
        self.view.addSubview(paymentField)
        

    }
    
    // MARK: STPPaymentCardTextFieldDelegate
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        cardParams.number = textField.cardParams.number
        cardParams.expMonth = textField.cardParams.expMonth
        cardParams.expYear = textField.cardParams.expYear
        cardParams.cvc = textField.cardParams.cvc
        self.createCardButton.isEnabled = textField.isValid
    }
  
    
    func createToken(cardParams: STPCardParams){

        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if error != nil {
                // show the error to the user
            } else if let token = token {
                self.submitTokenToBackend(token: token){completion in
                    if completion {
                        // show a receipt page
                    } else {
                        // show the error to the user
                    }
                }
            }
        }
    }
    
    
    
    
    func submitTokenToBackend(token: STPToken, callback: @escaping (_ completion: Bool)-> ()) {
            getTokensFromDB(){ dbTokens in
                
                let accessToken = dbTokens["accessToken"]!
                let refreshToken = dbTokens["refreshToken"]!

                let urlPath = "\(baseApiUrl)/users/user/\(LoginViewController.user.email!)"
                let url = NSURL(string: urlPath)
                let session = URLSession.shared
                let request = NSMutableURLRequest(url: url! as URL)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(accessToken, forHTTPHeaderField: "accessToken")
                request.addValue(refreshToken, forHTTPHeaderField: "refreshToken")
                request.httpMethod = "PUT"

                let jsonObject: [String: Any] = [
                    "token" : token.tokenId
                ]
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)             // do something with data
                    // if the call fails, the catch block is executed
                    
                    request.httpBody = jsonData
                    
                    let task = session.dataTask(with: request as URLRequest, completionHandler: {token, response, error -> Void in
                        
                        let httpResponse = response as? HTTPURLResponse;
                        
                        if(httpResponse != nil)
                        {
                            if(httpResponse!.statusCode == 200)
                            {
                                callback(true)
                            }
                            else
                            {
                                callback(false)
                            }
                        }
                        else
                        {
                            callback(false)
                        }
                        
                    })
                    task.resume()
                } catch {
                    callback(false)
                }
            }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
