//
//  KHSocialPlugin.m
//  KHSocialPlugin
//
//  Created by KempenHills on 10/26/12.
//
//  Copyright (C) 2012 KempenHills ICT B.V.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in
//  theSoftware without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
//  Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR
//  A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "KHSocialPlugin.h"

#define FB_APP_DISPLAY_NAME     @"Kempenhills Social Sharing"
#define FB_APP_CAPTION          @"Kempenhills Social Sharing on GITHub"
#define FB_APP_DESCRIPTION      @"The Social Sharing plugin makes your life allot easier when it comes to posting stuff to either Facebook or Twitter from a Cordova app!"

@implementation KHSocialPlugin


#pragma mark - 
#pragma mark General
/* 
    Create NSMutableDictionary from arguments. [{ key: value... }]  String from JS as command.arguments->0;
*/
- (NSMutableDictionary *)extractParamsFromCDVCommand:(CDVInvokedUrlCommand *)command {
    NSError* error = nil;
    NSMutableDictionary* params = [NSJSONSerialization JSONObjectWithData:[[command.arguments objectAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    return params;
}
/* 
    This is simply a forward from the AppDelegate's didFinishLaunchingWithOptions method.
*/
- (void) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions; {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSession];
    }
}

/* 
    This is simply a forward from the AppDelegate's handleOpenURL:notification method.
*/
-(void)handleOpenURL:(NSNotification *)notification {

}

/* 
    This is simply a forward from the AppDelegate's application:openURL:sourceApplication:annotation method.
*/
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSession activeSession] handleOpenURL:url];
}

/* 
    This is simply a forward from the AppDelegate's applicationDidBecomeActive method.
*/
-(void)applicationDidBecomeActive:(UIApplication *)application; {
    [[FBSession activeSession] handleDidBecomeActive];
}

#pragma mark -
#pragma mark Facebook

/*
    Try to Authorize with Facebook.
    Define your FacebookAppID in your <project_name>.plist like below.
    Replace <AppId> with the Application ID found on your app's development page.
    For detailed instructions follow the iOS SDK Tutorial on developer.facebook.com.
 
    <key>FacebookAppID</key>
	<string>360051114078976</string>
 
    <key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>fb<AppID></string>
			</array>
		</dict>
	</array>
*/
- (void)FBAuthorize:(CDVInvokedUrlCommand*)command; {
    if(callbacks == nil) {
        callbacks = [@{ @"FBAuthorize": command }mutableCopy];
    } else {
        [callbacks setObject:command forKey:@"FBAuthorize"];
    }
    [self openSession];
}

- (void) FBUnauthorize:(CDVInvokedUrlCommand*)command; {
    @try {
        [[FBSession activeSession] closeAndClearTokenInformation];
        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] toErrorCallbackString:command.callbackId]];
    } @catch (NSException* ex) {
        NSLog(@"%@", [ex reason]);
        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] toErrorCallbackString:command.callbackId]];
    }
}

/*
    Reports if the current FBSession is valid and opened to the assigned callback.
*/
- (void) FBGetLoginStatus:(CDVInvokedUrlCommand*)command; {
    CDVPluginResult* result = nil;
    NSString* javascript = nil;
    if([[FBSession activeSession] isOpen]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:YES];
        javascript = [result toSuccessCallbackString:command.callbackId];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:NO];
        javascript = [result toErrorCallbackString:command.callbackId];
    }
    [self writeJavascript:javascript];
}

/*
    Tries to present the user with the new iOS6 Native Dialog.
    When the application fails to do this, it falls back to the deprecated Facebook SDK to display a dialog.
*/
- (void) FBPostToUserTimeline:(CDVInvokedUrlCommand*)command; {
    @try {
        NSMutableDictionary *params = [self extractParamsFromCDVCommand:command];
        
        __strong NSString* textToShare = [params objectForKey:@"textToShare"];
        __strong NSString* imageUrlString = [params objectForKey:@"imageUrl"];
        __strong NSURL* url = [NSURL URLWithString:[params objectForKey:@"linkUrl"]];
        
        __block  UIImage* img = nil;
        __strong NSURL* imageURL = [NSURL URLWithString:imageUrlString];
        __block UIActivityIndicatorView* spinner = nil;
        __block UIViewController* blockViewController = self.viewController;
        
        void(^afterImageFetch)(void);

        afterImageFetch = ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [spinner removeFromSuperview];
                spinner = nil;
            });
            
            if([FBNativeDialogs canPresentShareDialogWithSession:[FBSession activeSession]]) {
                [FBNativeDialogs presentShareDialogModallyFrom:blockViewController initialText:textToShare images:img == nil? nil: @[img] urls:url == nil? nil : @[url] handler:^(FBNativeDialogResult result, NSError *error) {
                    if(result == FBNativeDialogResultError) {
                        [[[UIAlertView alloc] initWithTitle:@"Facebook Error" message:@"Could not post to Facebook at this time. Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                    } else if(result == FBNativeDialogResultSucceeded) {   
                        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:YES] toSuccessCallbackString:command.callbackId]];
                    }
                    if(error) {
                        NSLog(@"%@",[error localizedDescription]);
                        
                        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]] toErrorCallbackString:command.callbackId]];
                    }
                }];
            } else {
                if(self.facebook) {
                    //TODO - Use graph API to send a photo to your album before trying to post!
                    #warning Uploading local image files to Facebook has not yet been supported with the deprecated API. It may or may not be in a future release. Users wielding iOS6 and having logged into Facebook via settings will be able to post local image files without problems.
    
                    NSMutableDictionary *params = [@{
                        @"name":            FB_APP_DISPLAY_NAME,
                        @"caption":         FB_APP_CAPTION,
                        @"description" :    FB_APP_DESCRIPTION
                    } mutableCopy];
                    if(url != nil) {
                        [params setValue:[url absoluteString] forKey:@"link"];
                    }
                    if(imageURL != nil && [imageURL isFileURL]) {
                        [params setValue:[imageURL absoluteString] forKey:@"picture"];
                    }
                    
                    [self.facebook dialog:@"feed" andParams:[params mutableCopy] andDelegate:nil];
                }
            }
            img = nil;
        };
        
        if(imageUrlString != nil) {
            //imageUrl = [NSURL URLWithString:imageUrlString];
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.center = self.viewController.view.center;
            [self.viewController.view addSubview:spinner];
            [spinner startAnimating];
            
            if([self.imageUrl isFileURL]) {
                img = [UIImage imageWithContentsOfFile:[self.imageUrl relativePath]];
                afterImageFetch();
            } else if([FBNativeDialogs canPresentShareDialogWithSession:[FBSession activeSession]]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData* data = [NSData dataWithContentsOfURL:(NSURL*)imageURL];
                    img = [UIImage imageWithData:data];
                    afterImageFetch();
                });  
            } else {
                afterImageFetch();
            }
        } else {
            afterImageFetch();
        }
    } @catch (NSException* ex) {
        NSLog(@"%@", [ex reason]);
        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ex reason]] toErrorCallbackString: command.callbackId]];
    }
}

- (void)  FBSendAppRequestWithMessage:(CDVInvokedUrlCommand*)command {
    if(self.facebook) {
        NSMutableDictionary *params = [self extractParamsFromCDVCommand:command];

        [self.facebook dialog:@"apprequests" andParams:params andDelegate:nil];
    }
}

/*
    FBSession Delegate
*/
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
                NSLog(@"%@", @"Facebook has succesfully connected and logged into your account.");
                
                self.facebook = [[Facebook alloc] initWithAppId:[[FBSession activeSession] appID] andDelegate:nil];
                self.facebook.accessToken = [[FBSession activeSession] accessToken];
                self.facebook.expirationDate = [[FBSession activeSession] expirationDate];
            
                if(callbacks != nil) {
                    if([callbacks objectForKey:@"FBAuthorize"]) {
                        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                        CDVInvokedUrlCommand* command = [callbacks objectForKey:@"FBAuthorize"]? (CDVInvokedUrlCommand*)[callbacks objectForKey:@"FBAuthorize"]: nil;
                        if(command) {
                            [callbacks removeObjectForKey:@"FBAuthorize"];
                            [self writeJavascript:[result toSuccessCallbackString:command.callbackId]];
                        }
                    }
                }
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            self.facebook = nil;
            break;
        default:
            break;
    }

    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                     initWithTitle:@"Error"
                           message:error.localizedDescription
                          delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        [alertView show];
    }    
}

/*
    Try to open a session with publish_stream permission.
    Setting allowLoginUI to NO will prevent a Login Dialog from being opened when not logged in to Facebook via settings (iOS6), and thus nothing will happen.
*/
- (void)openSession
{
    [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
        completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
    }];
}

#pragma mark -
#pragma mark Twitter

-(void) TWGetLoginStatus :(CDVInvokedUrlCommand*)command; {
    if([TWTweetComposeViewController canSendTweet]) {
        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:YES] toSuccessCallbackString:command.callbackId]];
    } else {
        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:NO] toSuccessCallbackString:command.callbackId]];
    }
}

-(void) TWTweetToUserTimeline:(CDVInvokedUrlCommand*)command; {
    //Workaround for presenting the TWTweetcontroller before the CDVImagePicker is dismissed.
    if([[self.viewController presentedViewController] isBeingDismissed]) {
        [self performSelector:@selector(TWTweetToUserTimeline:) withObject:command afterDelay:0.1];
        return;
    };
    @try {
        __block NSString* callbackID = [command.callbackId copy];
        __strong NSMutableDictionary *params = [self extractParamsFromCDVCommand:command];
        __block TWTweetComposeViewController* tweetController = [[TWTweetComposeViewController alloc]init];
        __block UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self.viewController.view addSubview:spinner];
        spinner.center = self.viewController.view.center;
        [spinner startAnimating];
    
        void(^postTweet)(UIImage*);
        
        postTweet = ^(UIImage* img) {
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            spinner = nil;
            
            [tweetController addImage:img];
            if([params objectForKey:@"linkUrl"])
                [tweetController addURL:[NSURL URLWithString:[params objectForKey:@"linkUrl"]]];
            [tweetController setInitialText:[params objectForKey:@"textToShare"]];
            
            [tweetController setCompletionHandler: ^(TWTweetComposeViewControllerResult result) {
                switch(result) {
                    case TWTweetComposeViewControllerResultDone:
                        [tweetController dismissModalViewControllerAnimated:YES];
                        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:YES] toSuccessCallbackString:callbackID]];
                        break;
                    case TWTweetComposeViewControllerResultCancelled:
                        [tweetController dismissModalViewControllerAnimated:YES];
                        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsInt:NO] toSuccessCallbackString:callbackID]];
                        break;
                }
            }];
            [self.viewController presentViewController:tweetController animated:YES completion:nil];
        };
        
        if([params objectForKey:@"imageUrl"]) {
            __strong NSURL* imageUrl = [NSURL URLWithString:[params objectForKey:@"imageUrl"]];
            if([imageUrl isFileURL]) {
                //wait 1 sec in case of file pickers etc....
                int64_t delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    postTweet([UIImage imageWithContentsOfFile:[imageUrl relativePath]]);
                });
                
            } else {
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
                    NSData* data = [NSData dataWithContentsOfURL:imageUrl];
                    UIImage* img = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^() {
                        postTweet(img);
                    });
                });
            }
        } else {
            postTweet(nil);
        }
    } @catch (NSException* ex) {
        NSLog(@"TWTweetToUserTimeline::EXCEPTION :: %@", [ex reason]);
        [self writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[ex reason]] toErrorCallbackString: command.callbackId]];
    }
}

@end

