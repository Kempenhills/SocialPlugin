//
//  KHSocialPlugin.h
//  KHSocialPlugin
//
//  Created by KempenHills on 10/26/12.
//
//

#import <Cordova/CDV.h>
//#import <FacebookSDK/FacebookSDK.h> not needed because Facebook.h (deprecated version...) inclused the FacebookSDK!
#import "Facebook.h"
#import <Twitter/Twitter.h>

@interface KHSocialPlugin : CDVPlugin {
    NSMutableDictionary* callbacks;
}

@property (nonatomic, strong) Facebook* facebook;
@property (nonatomic, strong) NSURL* imageUrl;

- (void) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions;
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)applicationDidBecomeActive:(UIApplication *)application;

@end
