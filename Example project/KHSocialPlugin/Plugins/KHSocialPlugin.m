//
//  KHSocialPlugin.m
//  KHSocialPlugin
//
//  Created by KempenHills on 10/26/12.
//
//  Copyright (C) 2012 KempenHills ICT BV
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
- (void) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions; {
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes
        [self openSession];
    } else {
        // No
    }
}

-(void)handleOpenURL:(NSNotification *)notification {

}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSession activeSession] handleOpenURL:url];
}
-(void)applicationDidBecomeActive:(UIApplication *)application; {
    [[FBSession activeSession] handleDidBecomeActive];
}
#pragma mark -
#pragma mark Facebook
- (void)FBAuthorize:(CDVInvokedUrlCommand*)command; {
    [self openSession];
}

- (void) FBGetLoginStatus:(CDVInvokedUrlCommand*)command; {
    CDVPluginResult* result = nil;
    NSString* javascript = nil;
    if([[FBSession activeSession] isOpen]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        javascript = [result toSuccessCallbackString:command.callbackId];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        javascript = [result toErrorCallbackString:command.callbackId];
    }
    [self writeJavascript:javascript];
}
 
- (void) FBPostToUserTimeline:(CDVInvokedUrlCommand*)command; {
    @try {
        
        __strong NSString* textToShare = ( NSString*) [command.arguments objectAtIndex:0];
        __strong NSString* imageUrlString = [command.arguments objectAtIndex:1];
        __block  UIImage* img = nil;
        __strong NSURL* imageURL = [NSURL URLWithString:imageUrlString];
        __block UIActivityIndicatorView* spinner = nil;
        __strong NSURL* url = [NSURL URLWithString:[command.arguments objectAtIndex:2]];
        __block UIViewController* blockViewController = self.viewController;
        
        //Define the block
        void(^afterImageFetch)(void);
        
        //Implement the block
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
                    }
                    if(error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                }];
            } else {
                if(self.facebook) {
                    //TODO - Use graph API to send a photo to your album before trying to post!
                    NSLog(@"%@", @"Uploading local image files to Facebook has not yet been supported with the deprecated API. It may or may not be in a future release. Users wielding iOS6 and having logging Logged into Facebook via settings will be able to post local image files without problems.");
                    NSDictionary *params = @{
                        @"name": FB_APP_DISPLAY_NAME,
                        @"caption": FB_APP_CAPTION,
                        @"description" : FB_APP_DESCRIPTION,
                        @"link" : url == nil? nil : [url absoluteString],
                        @"picture" :  [imageURL isFileURL]? @"" : [imageURL absoluteString]
                    };
                    
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
                img = [UIImage imageWithContentsOfFile:[self.imageUrl absoluteString]];
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
        }
    } @catch (NSException* ex) {
        NSLog(@"%@", [ex reason]);
    }
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
                NSLog(@"%@", @"Facebook has succesfully connected and logged into your account.");
                if(nil == self.facebook) {
                    self.facebook = [[Facebook alloc] initWithAppId:[[FBSession activeSession] appID] andDelegate:nil];
                    self.facebook.accessToken = [[FBSession activeSession] accessToken];
                    self.facebook.expirationDate = [[FBSession activeSession] expirationDate];
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

- (void)openSession
{
    [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
        completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
    }];
}

@end
