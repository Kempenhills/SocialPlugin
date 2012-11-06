#Social Sharing

![KempenHills Logo](http://en.gravatar.com/userimage/41641793/5ecd217ad2bec9299b198ff39a95b463.png?size=200)

The Social Sharing plugin makes your life a lot easier when it comes to interacting with either Facebook or Twitter from a Cordova app!
With this plugin it is fairly simple to authenticate and post to Facebook and Twitter. It focuses on the Single Sign On techniques both the Facebook and Twitter SDK use. 

When a user hasn't logged in to his Native Facebook settings or uses iOS5.x the Facebook SDK falls back to the old style. Meaning dialogs and app-switching when logging in and or posting.

In the case of Twitter it brings up the Tweetpanel AND a alertView to log in to Twitter.

Feel free to improve or upgrade the plugin!

## How to use
First we must include all the right files to our project.

1. ### Javascript
	* Copy the www/js/ folder into your project.
	* Include the khsocialplugin.js in your html header file

2. ### iOS
	* Copy the content of native/ios/ into your project's plugins group
	* Add the mapping 'KHSocialPlugin' -> 'KHSocialPlugin' to cordova.plist
    * Add Twitter.framework to your project's frameworks in Target -> Build Phases -> Link binary with library
	* Include the Facebook SDK **AND** Deprecated header. <a href="https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/3.1/">Facebook iOS SDK tutorial</a> <a href="https://developers.facebook.com/docs/howtos/feed-dialog-using-ios-sdk/">Step 2. 'Backwards compatability'</a><br />
	* Replace the last part of the AppDelegate.m's application:application didFinishLaunchingWithOptions:launchOptions with the following:
    
```javascript
self.window.rootViewController = self.viewController;
[self.window makeKeyAndVisible];

[(KHSocialPlugin*)[self.viewController getCommandInstance:@"KHSocialPlugin"] application:application didFinishLaunchingWithOptions:launchOptions];

return YES;
```

* Add the following block to the AppDelegate.m
    

```
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        KHSocialPlugin* khsp = [self.viewController getCommandInstance:@"KHSocialPlugin"];
    return [khsp application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

-(void)applicationDidBecomeActive:(UIApplication *)application; {
    KHSocialPlugin* khsp = [self.viewController getCommandInstance:@"KHSocialPlugin"];
    [khsp applicationDidBecomeActive:application];
}
```

* Thats all for iOS, Happy sharing!

______________________________

**The javascript calls are easy to learn. Check out the example project for further reference!**

```javascript

navigator.camera.getPicture(function(imgURI){
        window.plugins.KHSocialPlugin.FBPostToUserTimeline('Check out the brand new Kempenhills Social Plugin! Using local images!', imgURI,'https://github.com/Kempenhills/SocialPlugin');
    }, function(e){}, {
        quality:            40,
        destinationType:    Camera.DestinationType.FILE_URI,
        sourceType :        Camera.PictureSourceType.PHOTOLIBRARY,
        correctOrientation: true
    });

```

## MIT LICENSE

Copyright (C) 2012 KempenHills ICT BV

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.