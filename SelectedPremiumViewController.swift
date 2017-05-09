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
