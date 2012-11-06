#Social Sharing

![KempenHills Logo](http://en.gravatar.com/userimage/41641793/5ecd217ad2bec9299b198ff39a95b463.png?size=200)

The Social Sharing plugin makes your life a lot easier when it comes to interacting with either Facebook or Twitter from a Cordova app!

## How to use
First we must include all the right files to our project.
1. Javascript
	* Copy the www/js/ folder into your project.
	* Include the khsocialplugin.js in your html header file

2. iOS
	* Copy the content of native/ios/ into your project's plugins group
	* Add the mapping 'KHSocialPlugin' -> 'KHSocialPlugin' to cordova.plist
	* Include the Facebook SDK **AND** Deprecated header. <a href="https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/3.1/">Facebook iOS SDK tutorial</a> <a href="https://developers.facebook.com/docs/howtos/feed-dialog-using-ios-sdk/">Step 2. 'Backwards compatability'</a><br />
	* Add ```
[(KHSocialPlugin*)[self.viewController getCommandInstance:@"KHSocialPlugin"] 
	application:application didFinishLaunchingWithOptions:launchOptions];
``` 
to the bottom of your AppDelegate.m's applicationDidFinishLaunching:withOptions method, right above the return YES; statement



## MIT LICENSE

Copyright (C) 2012 KempenHills ICT BV

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.