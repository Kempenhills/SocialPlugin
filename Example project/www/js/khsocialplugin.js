//
//  KHSocialPlugin.js
//
// Created by Roy Derks on 26/10/12.
//
// Copyright 2012 Kempenhills ICT BV. All rights reserved.

(function(cordova) {

	function KHSocialPlugin() {}

    //#     FACEBOOK

	// Call this to register for push notifications and retreive a deviceToken
	KHSocialPlugin.prototype.FBAuthorize = function(cb) {
		cordova.exec(cb, null, "KHSocialPlugin", "FBAuthorize", []);
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
