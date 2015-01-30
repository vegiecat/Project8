//
//  FBHelper.swift
//  Project8
//
//  Created by Vegiecat Studio on 11/25/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import Foundation




class FBHelper{
    
    
    func FBUserLoggedin() -> Bool{
        
        // If the session state is any of the two "open" states means, user is logged in
        if FBSession.activeSession().state == FBSessionState.Open
        || FBSession.activeSession().state == FBSessionState.OpenTokenExtended {
            
            //Present loggedin state.
            //FBBtnLoginLogout.setTitle("Log Out", forState: UIControlState.Normal)
            return true
            
        // If the session state is not any of the two "open" states meaning the user is lot logged in
        } else {
            
            //Present the not-loggedin State
            return false
        }
    }

    
    
    func FBAlbumSampleTest(){
        var albumParams = ["name": "testAlbumSWIFT", "message": "Hello World Album"] as NSDictionary
        let stepsData = [["url": "http://dummyimage.com/640x4:3", "message": "Hello World Album Image"]]
        var photoParams = ["url": "http://dummyimage.com/640x4:3", "message": "Hello World Album Image"] as NSDictionary
        self.FBAlbumPublish(albumParams, stepsData: stepsData)
    }
    
    
    func FBPrepareRecipeForAlbumWith(recipe:Recipe) -> (albumData: NSDictionary,stepsData: [AnyObject]){
        
        let recipeCoverPhoto:UIImage? = UIImage(data: recipe.coverPhoto)?
        var albumParam = ["name": recipe.name, "message": "Hello World Album"] as NSDictionary
        
        var stepsParam:[NSDictionary] = []
        
        for step in recipe.step.array{
            let singleStep = step as Step
            //let stepsPhoto:UIImage? = UIImage(data: recipe.coverPhoto)?
            let singleStepParam = ["source": UIImage(data: singleStep.stepImage)!, "message": singleStep.stepText] as NSDictionary
            stepsParam.append(singleStepParam)
        }

        
//        let stepsPhoto:UIImage? = UIImage(data: recipe.coverPhoto)?
//
//        var photo = ["source": recipeCoverPhoto!, "message": "Hello World Album Image"] as NSDictionary
//        photoParams.append(photo)

        
        return(albumParam, stepsParam)
        
    }

    
    
    func FBAlbumPublish(albumData:NSDictionary, stepsData:NSArray){
        //Create the album
        FBRequestConnection.startWithGraphPath(
            "me/albums",
            parameters: albumData,
            HTTPMethod:"POST",
            completionHandler: {
                connection, result, error in
                println("\(result)")
                var jsonValue = result as FBGraphObject
                var tempID = jsonValue["id"] as String
                println("\(tempID)")
                
                
                //upload the steps
                for singleStepParam in stepsData{
                    FBRequestConnection.startWithGraphPath(
                        "/\(tempID)/photos",
                        parameters: singleStepParam as NSDictionary,
                        HTTPMethod:"POST",
                        completionHandler: {
                            connection, result, error in
                            println("\(result)")
                            
                        } as FBRequestHandler
                    )
                
                }
        
            } as FBRequestHandler
        );
        println("I shared a new recipe on FB")
    }

    
    
/*
    var fbSession:FBSession?;
    init(){
        self.fbSession = nil;
    }
    
    func fbAlbumRequestHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!){
        
        if let gotError = error{
            println(gotError.description);
        }
        else{
            let graphData = result.valueForKey("data") as Array;
            var albums:AlbumModel[] =  AlbumModel[]();
            for obj:FBGraphObject in graphData{
                let desc = obj.description;
                println(desc);
                let name = obj.valueForKey("name") as String;
                println(name);
                if(name == "ETC"){
                    let test="";
                }
                let id = obj.valueForKey("id") as String;
                var cover = "";
                if let existsCoverPhoto : AnyObject = obj.valueForKey("cover_photo"){
                    let coverLink = existsCoverPhoto  as String;
                    cover = "/\(coverLink)/photos";
                }
                
                //println(coverLink);
                let link = "/\(id)/photos";
                
                let model = AlbumModel(name: name, link: link, cover:cover);
                albums.append(model);
                
            }
            NSNotificationCenter.defaultCenter()?.postNotificationName("albumNotification", object: nil, userInfo: ["data":albums]);
        }
    }
    
    func fetchPhoto(link:String){
        let fbRequest = FBRequest.requestForMe();
        fbRequest.graphPath = link;
        fbRequest.startWithCompletionHandler(fetchPhotosHandler);
    }
    
    func fetchPhotosHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!){
        if let gotError = error{
            
        }
        else{
            var pictures:UIImage[] = UIImage[]();
            let graphData = result.valueForKey("data") as Array;
            var albums:AlbumModel[] =  AlbumModel[]();
            for obj:FBGraphObject in graphData{
                println(obj.description);
                let pictureURL = obj.valueForKey("picture") as String;
                let url = NSURL(string: pictureURL);
                let picData = NSData(contentsOfURL: url);
                let img = UIImage(data: picData);
                pictures.append(img);
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("photoNotification", object: nil, userInfo: ["photos":pictures]);
        }
    }
    
    func fetchAlbum(){
        
        let request =  FBRequest.requestForMe();
        request.graphPath = "me/albums";
        
        request.startWithCompletionHandler(fbAlbumRequestHandler);
    }
    
    func logout(){
        self.fbSession?.closeAndClearTokenInformation();
        self.fbSession?.close();
    }
    
    func login(){
        let activeSession = FBSession.activeSession();
        let fbsessionState = activeSession.state;
        if(fbsessionState.value != FBSessionStateOpen.value &amp;&amp; fbsessionState.value != FBSessionStateOpenTokenExtended.value){
            
            let permission = ["basic_info", "email","user_photos","friends_photos"];
            
            FBSession.openActiveSessionWithPublishPermissions(permission, defaultAudience: FBSessionDefaultAudienceFriends, allowLoginUI: true, completionHandler: self.fbHandler);
            
        }
    }
    
    func fbHandler(session:FBSession!, state:FBSessionState, error:NSError!){
        if let gotError = error{
            //got error
        }
        else{
            
            self.fbSession = session;
            
            FBRequest.requestForMe()?.startWithCompletionHandler(self.fbRequestCompletionHandler);
        }
    }
    
    func fbRequestCompletionHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!){
        if let gotError = error{
            //got error
        }
        else{
            //let resultDict = result as Dictionary;
            //let email = result["email"];
            //let firstName = result["first_name"];
            
            let email : AnyObject = result.valueForKey("email");
            let firstName:AnyObject = result.valueForKey("first_name");
            let userFBID:AnyObject = result.valueForKey("id");
            let userImageURL = "https://graph.facebook.com/\(userFBID)/picture?type=small";
            
            let url = NSURL.URLWithString(userImageURL);
            
            let imageData = NSData(contentsOfURL: url);
            
            let image = UIImage(data: imageData);
            
            println("userFBID: \(userFBID) Email \(email) \n firstName:\(firstName) \n image: \(image)");
            
            var userModel = User(email: email, name: firstName, image: image);
            
            NSNotificationCenter.defaultCenter().postNotificationName("PostData", object: userModel, userInfo: nil);
            
        }
    }
*/
}





