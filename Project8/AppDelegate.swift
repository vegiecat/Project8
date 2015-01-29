//
//  AppDelegate.swift
//  Project8
//
//  Created by Vegiecat Studio on 11/21/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//  Testing Branch Here


import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Whenever a person opens the app, check for a cached session
        if FBSession.activeSession().state == FBSessionState.CreatedTokenLoaded {
            println("Found a cached FB session")
            
            // If there's one, just open the session silently, without showing the user the login UI
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: false, completionHandler: {
                (session, state, error) -> Void in
                // Handler for session state changes
                // This method will be called EACH time the session state changes,
                // also for intermediate states and NOT just when the session open
                self.sessionStateChanged(session, state: state, error: error)
            })
        }else{
            // If there's no cached session, we will show a login button

        }
        return true
    }

    func sessionStateChanged(session : FBSession, state : FBSessionState, error : NSError?){
        // If the session was opened successfully
        if  state == FBSessionState.Open && error == nil{
            println("FB Session Opened")
            // Show the user the logged-in UI
            self.userLoggedIn()
            return
        }
        // If the session closed
        if state == FBSessionState.Closed || state == FBSessionState.ClosedLoginFailed{
            println("FB Session Closed")
            // Show the user the logged-out UI
            self.userLoggedOut()
            return
        }
        
        // Handle errors
        if error != nil{
            println("FB error")
            var alertText:String
            var alerTitle:String
            // If the error requires people using an app to make an action outside of the app in order to recover
            if FBErrorUtility.shouldNotifyUserForError(error) == true{
                alerTitle = "Something in FB Login went wrong"
                alertText = FBErrorUtility.userMessageForError(error)
                self.showMessage(alertText, withTitle: alerTitle)
            }else {
                // If the user cancelled login, do nothing
                if FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.UserCancelled{
                    println("User canceled FB login")
                
                // Handle session closures that happen outside of the app
                }else if FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession{
                    alerTitle = "FB Session Error"
                    alertText = "Your current FB session is no longer valid. Please log in again."
                    self.showMessage(alertText, withTitle: alerTitle)

                // For simplicity, here we just show a generic message for all other errors
                // We can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
                }else{
                    //Get more error information from the error
                    if let info = error!.userInfo{
                        if let dict1 = info["com.facebook.sdk:ParsedJSONResponseKey"] as? NSDictionary {
                            if let dict2 = dict1["body"] as? NSDictionary {
                                if let errorInformation = dict2["error"] as? NSDictionary {
                                    if let msg:AnyObject = errorInformation["message"] {
                                        println("errormessage: \(msg)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Clear this token
            FBSession.activeSession().closeAndClearTokenInformation()
            // Show the user the logged-out UI
            self.userLoggedOut()
        }

        
    }

    func showMessage(message:String, withTitle:String){
        //Switch to UIAlertController later
        let alert = UIAlertView()
        alert.title = withTitle
        alert.message = message
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    func userLoggedIn(){
        
    }

    func userLoggedOut(){
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Whenever a person opens the app, check for a cached session
        
        /*

        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            NSLog(@"Found a cached session");
            // If there's one, just open the session silently, without showing the user the login UI
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
            allowLoginUI:NO
            completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            // Handler for session state changes
            // This method will be called EACH time the session state changes,
            // also for intermediate states and NOT just when the session open
            [self sessionStateChanged:session state:state error:error];
            }];
            
            // If there's no cached session, we will show a login button
        } else {
            UIButton *loginButton = [self.customLoginViewController loginButton];
            [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
        }
        */

        FBLoginView.self
        FBProfilePictureView.self
        
        //Testing Global Variable
        //NSUserDefaults.standardUserDefaults().setBool(Bool(), forKey: "P8DataCoreHelperDebugMode")
        
        return true
    }
    
    

    
    // During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
    // After authentication, your app will be called back with the session information.
    // Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: NSString?,
        annotation: AnyObject) -> Bool {
            
            var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
            return wasHandled
            
    }

    
    
    
    
    
    
    
    
    
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        // Handle the user leaving the app while the Facebook login dialog is being shown
        // For example: when the user presses the iOS "home" button while the login dialog is active
        FBAppCall.handleDidBecomeActive()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "vegiecatstudio.Project8" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Project8", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Project8.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

