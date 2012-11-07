//
// KHSocialPlugin.js
//
// Created by KempenHills ICT B.V. on 26/10/12.
//
// Copyright (C) 2012 KempenHills ICT B.V.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the
// Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// 

(function(cordova) {

	function KHSocialPlugin() {}

    //#     FACEBOOK
	KHSocialPlugin.prototype.FBAuthorize = function(cb) {
		cordova.exec(cb, null, "KHSocialPlugin", "FBAuthorize", []);
	};
 
    KHSocialPlugin.prototype.FBUnauthorize = function() {
		cordova.exec(null, null, "KHSocialPlugin", "FBUnauthorize", []);
	};
 
    KHSocialPlugin.prototype.FBGetLoginStatus = function(cb, failCb) {
        cordova.exec(cb, failCb, "KHSocialPlugin", "FBGetLoginStatus", []);
    }
 
    KHSocialPlugin.prototype.FBPostToUserTimeline = function(textToShare, imageUrl, linkUrl, cb, failCb) {
        cordova.exec(cb, failCb, "KHSocialPlugin", "FBPostToUserTimeline", [JSON.stringify({ 'textToShare': textToShare, 'imageUrl' : imageUrl, 'linkUrl': linkUrl})]);
    }
 
    KHSocialPlugin.prototype.FBSendAppRequestWithMessage = function(message, to, cb, failCb) {
        cordova.exec(cb, failCb, "KHSocialPlugin", "FBSendAppRequestWithMessage", [JSON.stringify({ 'message': message, 'to': to })]);
    }
 
    //#     TWITTER
    KHSocialPlugin.prototype.TWGetLoginStatus = function(cb, failCb) {
        cordova.exec(cb, failCb, "KHSocialPlugin", "TWGetLoginStatus", []);
    }
 
    KHSocialPlugin.prototype.TWTweetToUserTimeline = function(textToShare, imageUrl, linkUrl, cb, failCb) {
        cordova.exec(cb, failCb, "KHSocialPlugin", "TWTweetToUserTimeline", [JSON.stringify({
            'textToShare':  textToShare,
            'imageUrl':     imageUrl,
            'linkUrl':      linkUrl,
        })]);
    }
 
 
	if(!window.plugins) window.plugins = {};
	window.plugins.KHSocialPlugin = new KHSocialPlugin();

})(window.cordova || window.Cordova || window.PhoneGap);
