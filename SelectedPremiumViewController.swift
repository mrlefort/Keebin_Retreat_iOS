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
    @IBAction func tilmeldButton(_ sender: Any) {
        let payment = MobilePayPayment(orderId: "123456", productPrice: 10.0)
        //No need to start a payment if one or more parameters are missing
        if (payment != nil) && ((payment?.orderId.characters.count)! > 0) && ((payment?.productPrice)! >= 0) {
            MobilePayManager.sharedInstance().beginMobilePayment(with: payment!, error: { (Error) in
                print(Error)
                self.alert(message: Error.localizedDescription)
            })
        }
    }


    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white;
        premiumInfoTextBox.text = "Premium er for dig som elsker kaffe. Ved at abonnere på Premium får du 1 kop gratis kaffe hver uge! Du går ned til en RetreatFood efter dit valg, bestiller en kop kaffe og viser din Premium side, samt giver baristaen dit brugerID. Så får du en kop kaffe, uden at skulle betale for den."
        premiumPris.text = "Premium koster kun 75kr om måneden."
        

        // Do any additional setup after loading the view.
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
