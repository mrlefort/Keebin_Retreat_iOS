//
//  Settings.swift
//  Keebin_development_1
//
//  Created by sr on 27/03/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit
import Stripe

class Settings: UIViewController {

    func buyButtonTapped() {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = (self as! STPAddCardViewControllerDelegate)
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        self.submitTokenToBackend(token, completion: { (error: Error?) in
            if let error = error {
                completion(error)
            } else {
                self.dismiss(animated: true, completion: {
                    self.showReceiptPage()
                    completion(nil)
                })
            }
        })
    }
    
    //Hvordan skal denne func se ud?
    func submitTokenToBackend(){
        
    }
    
    
    @IBAction func stripeTest(_ sender: Any) {
        buyButtonTapped()
    }
    
    @IBOutlet weak var email: UIButton!

    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var aboutme: UIButton!
    @IBOutlet weak var password: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        email.layer.cornerRadius = 10;
        email.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
  
 
        
        aboutme.layer.cornerRadius = 10;
        aboutme.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        password.layer.cornerRadius = 10;
        password.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

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
