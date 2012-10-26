//
//  KHSocialPlugin.m
//  KHSocialPlugin
//
//  Created by KempenHills on 10/26/12.
//
//

#import "KHSocialPlugin.h"

#import <Cordova/CDV.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation KHSocialPlugin

#pragma mark - 
#pragma mark General
- (void) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions; {

}

-(void)handleOpenURL:(NSNotification *)notification {

}

#pragma mark -
#pragma mark Facebook
- (void)FBAuthorize:(CDVInvokedUrlCommand*)command; {

}

- (void) FBPostToUserWall:(CDVInvokedUrlCommand*)command; {

}

@end
