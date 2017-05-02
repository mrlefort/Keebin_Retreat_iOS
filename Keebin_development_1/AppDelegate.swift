//
//  AppDelegate.swift
//  Keebin_development_1
//
//  Created by Steffen Lefort on 01/02/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
 
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    

    func application(_ app: UIApplication, open url: URL, options: [String: Any]) -> Bool {
        //IMPORTANT - YOU MUST USE THIS IF YOU COMPILING YOUR AGAINST IOS9 SDK
        DispatchQueue.main.async {

            self.handleMobilePayPayment(with: url)
            
        }
        return true
        
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        //IMPORTANT - THIS IS DEPRECATED IN IOS9 - USE 'application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options' INSTEAD
//        handleMobilePayPayment(with: url)
//        return true
//    }
//
//    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//        //IMPORTANT - THIS IS DEPRECATED IN IOS9 - USE 'application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options' INSTEAD
//        handleMobilePayPayment(with: url)
//        return true
//    }
    
    func handleMobilePayPayment(with url: URL) {
        var LVC = Settings()
        MobilePayManager.sharedInstance().handleMobilePayPayment(with: url, success: {( mobilePaySuccessfulPayment: MobilePaySuccessfulPayment?) -> Void in
            let orderId: String = mobilePaySuccessfulPayment!.orderId
            let transactionId: String = mobilePaySuccessfulPayment!.transactionId
            let amountWithdrawnFromCard: String = "\(mobilePaySuccessfulPayment!.amountWithdrawnFromCard)"
            print("MobilePay purchase succeeded: Your have now paid for order with id \(orderId) and MobilePay transaction id \(transactionId) and the amount withdrawn from the card is: \(amountWithdrawnFromCard)")
            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                 LVC.alert(message: "You have now paid with MobilePay. Your MobilePay transactionId is \(transactionId)", title: "MobilePay Succeeded")
            }
            
            
            
        }, error: {( error: Error?) -> Void in
//            let dict: [AnyHashable: Any]? = error?.userInfo
//            let errorMessage: String? = (dict?.value(forKey: NSLocalizedFailureReasonErrorKey) as? String)
//            print("MobilePay purchase failed:  Error code '(Int(error?.code))' and message '(errorMessage)'")
//            self.alert(message: errorMessage!, title: "MobilePay Error \(error?.code as! Int)")
            DispatchQueue.main.async {
                LVC.alert(message: error as! String)
            }
            
            //TODO: show an appropriate error message to the user. Check MobilePayManager.h for a complete description of the error codes
            //An example of using the MobilePayErrorCode enum
            //if (error.code == MobilePayErrorCodeUpdateApp) {
            //    NSLog(@"You must update your MobilePay app");
            //}
        }, cancel: {(_ mobilePayCancelledPayment: MobilePayCancelledPayment?) -> Void in
            DispatchQueue.main.async {
                LVC.alert(message: "You cancelled the payment flow from MobilePay, please pick a fruit and try again", title: "MobilePay Canceled")

            }
            print("MobilePay purchase with order id \(mobilePayCancelledPayment?.orderId!) cancelled by user")
                    })
    }


    
    // MARK: - Core Data stack
    

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Keebin_development_1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

