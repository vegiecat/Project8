//
//  P8DebugFaceBookTableView.swift
//  Project8
//
//  Created by Vegiecat Studio on 1/19/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

import UIKit
import Foundation
class P8DebugFaceBookTableView: UIViewController {

    let fbHelper = FBHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        if fbHelper.FBUserLoggedin(){
            FBBtnLoginLogout.setTitle("Log Out of Facebook", forState: UIControlState.Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func doneAction(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    //var sources:AlbumModel[] = AlbumModel[]();
    //var currentAlbumModel = AlbumModel(name: "", link: "", cover:"");
    //var destController:AlbumViewController?;
    
    //@IBOutlet var albumTable : UITableView
    //@IBOutlet var imgProfile : UIImageView
    
    /*
    @IBAction func fetchDataAction(sender : AnyObject) {
        fbHelper.fetchAlbum();
    }
    */
    
    
    @IBOutlet var FBBtnLoginLogout: UIButton!
    
    
    @IBAction func buttonTouched(sender:AnyObject){
        // If the session state is any of the two "open" states when the button is clicked
        if FBSession.activeSession().state == FBSessionState.Open
            || FBSession.activeSession().state == FBSessionState.OpenTokenExtended {
                
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                FBSession.activeSession().closeAndClearTokenInformation()
                
                FBBtnLoginLogout.setTitle("Log in with FB", forState: UIControlState.Normal)
                
                
                // If the session state is not any of the two "open" states when the button is clicked
        } else {
            
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            FBSession.openActiveSessionWithReadPermissions(["public_profile"], allowLoginUI: true, completionHandler: {
                (session:FBSession!, state:FBSessionState, error:NSError!) in
                // Retrieve the app delegate
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                appDelegate.sessionStateChanged(session, state: state, error: error)
                self.FBBtnLoginLogout.setTitle("Log Out of Facebook", forState: UIControlState.Normal)

            })
        }
    }
    
    /*
    @IBAction func facebookLogoutAction(sender : AnyObject) {
        self.fbHelper.logout();
        self.FBBtnLoginLogout.titleLabel.text = "Login with Facebook";
    }
    @IBAction func facebookLoginAction(sender : AnyObject) {
        
        if(self.FBBtnLoginLogout.titleLabel.text == "Login with Facebook"){
            fbHelper.login();
        }
        else{
            fbHelper.logout();
        }
        
    }
    */

    @IBAction func btnCheckForFBPublishPermissions(sender: AnyObject) {
        if fbHelper.FBUserLoggedin(){
            println("FB Logged-in")
        }else{
            println("FB Logged-out")
        }
    }

    
    @IBAction func albumPostTest(sender: AnyObject) {
        
        FBRequestConnection.startWithGraphPath(
            "/me/permissions",
            parameters: nil,
            HTTPMethod:"GET",
            completionHandler: {
                (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                if (result? != nil) {
                    var hasPublishPermission = false
                    var permData = result as FBGraphObject
                    var permArray = permData["data"] as NSArray
                    println("getting permissions: \(permArray)")
                    
                    //loop through the permissions looking for FB publish actions
                    for perm in permArray{
                        println(perm["permission"])
                        //check for the permission for publish_permission
                        if perm["permission"]! as String == "publish_actions" && perm["status"]! as String == "granted"{
                            println("YES")
                            hasPublishPermission = true
                            println("now turn the var to true:\(hasPublishPermission)")
                        }
                        
                    }
                    
                    //has permission. publish the image.
                    if hasPublishPermission{
                        self.publishAlbum()
                        
                    // doesn't have permission, request it.
                    }else{
                        let publishPermission = ["publish_actions"]
                        FBSession.activeSession().requestNewPublishPermissions(
                            publishPermission,
                            defaultAudience: FBSessionDefaultAudience.Friends) {
                                (currentSession:FBSession!, error:NSError!) -> Void in
                                println(currentSession)
                                
                                if error != nil{
                                    //print the error and figure out what to do.
                                    println(error)
                                }else{
                                    self.publishAlbum()
                                }
                        }
                    }
                }
                } as FBRequestHandler
        )
        

        
/*
        //check for FB publish actions permission
        FBRequestConnection.startWithGraphPath(
            "/me/permissions",
            parameters: nil,
            HTTPMethod:"GET",
            completionHandler: {
                (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                if (result? != nil) {
                    var hasPublishPermission = false
                    var permData = result as FBGraphObject
                    var permArray = permData["data"] as NSArray
                    println("getting permissions: \(permArray)")
                    
                    //loop through the permissions looking for FB publish actions
                    for perm in permArray{
                        println(perm["permission"])
                        
                        //has permission. publish the image.
                        if perm["permission"]! as String == "publish_actions" && perm["status"]! as String == "granted"{
                            println("YES")
                            hasPublishPermission = true
                            println("now turn the var to true:\(hasPublishPermission)")
                            
                            self.publishAlbum()
                            
                        
                        // doesn't have permission, request it.
                        }else{
                            let publishPermission = ["publish_actions"]
                            FBSession.activeSession().requestNewPublishPermissions(
                                publishPermission,
                                defaultAudience: FBSessionDefaultAudience.Friends) {
                                    (currentSession:FBSession!, error:NSError!) -> Void in
                                    
                                    //check if permission granted
                                    println(currentSession)
                            }
                        }
                    }
                }
            } as FBRequestHandler
        )

*/
    }
    
    func publishAlbum(){
        fbHelper.FBAlbumSampleTest()
    }
    
    func checkForFBPublishPermissions() ->Bool{
        var hasPublishPermission = false
        FBRequestConnection.startWithGraphPath(
            "/me/permissions",
            parameters: nil,
            HTTPMethod:"GET",
            completionHandler: {
            (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                if (result? != nil) {
                    NSLog("error = \(error)")
                    var permData = result as FBGraphObject
                    var permArray = permData["data"] as NSArray
                    println(permArray)
                    for perm in permArray{
                        println(perm["permission"])
                        if perm["permission"]! as String == "publish_actions" && perm["status"]! as String == "granted"{
                            println("YES")
                            hasPublishPermission = true
                            println("now turn the var to true:\(hasPublishPermission)")
                        }
                    }
                }
            } as FBRequestHandler
        )
        println(hasPublishPermission)
        return hasPublishPermission
    }
    
    func requestForFBPublishPermissions()->Bool{
        let publishPermission = ["publish_actions"]
        FBSession.activeSession().requestNewPublishPermissions(publishPermission,
            defaultAudience: FBSessionDefaultAudience.Friends) { (currentSession:FBSession!, error:NSError!) -> Void in
                println(currentSession)
        }
        return true
    }

/*
    // Request publish_actions
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
    defaultAudience:FBSessionDefaultAudienceFriends
    completionHandler:^(FBSession *session, NSError *error) {
    __block NSString *alertText;
    __block NSString *alertTitle;
    if (!error) {
    if ([FBSession.activeSession.permissions
    indexOfObject:@"publish_actions"] == NSNotFound){
    // Permission not granted, tell the user we will not publish
    alertTitle = @"Permission not granted";
    alertText = @"Your action will not be published to Facebook.";
    [[[UIAlertView alloc] initWithTitle:alertTitle
    message:alertText
    delegate:self
    cancelButtonTitle:@"OK!"
    otherButtonTitles:nil] show];
    } else {
    // Permission granted, publish the OG story
    [self publishStory];
    }
    
    } else {
    // There was an error, handle it
    // See https://developers.facebook.com/docs/ios/errors/
    }
    }];
*/
    
    
    
/*
    // Check for publish permissions
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    __block NSString *alertText;
    __block NSString *alertTitle;
    if (!error){
    // Walk the list of permissions looking to see if publish_actions has been granted
    NSArray *permissions = (NSArray *)[result data];
    BOOL publishActionsSet = FALSE;
    for (NSDictionary *perm in permissions) {
    if ([[perm objectForKey:@"permission"] isEqualToString:@"publish_actions"] &&
    [[perm objectForKey:@"status"] isEqualToString:@"granted"]) {
    publishActionsSet = TRUE;
    NSLog(@"publish_actions granted.");
    break;
    }
    }
    if (!publishActionsSet){
    // Publish permissions not found, ask for publish_actions
    [self requestPublishPermissions];
    
    } else {
    // Publish permissions found, publish the OG story
    [self publishStory];
    }
    
    } else {
    // There was an error, handle it
    // See https://developers.facebook.com/docs/ios/errors/
    }
    }];
*/
    
    
    
    
    
    
    
    
}
