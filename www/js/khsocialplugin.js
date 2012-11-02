//
//  KHSocialPlugin.js
//
// Created by Roy Derks on 26/10/12.
//
// Copyright 2012 Kempenhills ICT BV. All rights reserved.

(function(cordova) {

	function KHSocialPlugin() {}

	// Call this to register for push notifications and retreive a deviceToken
	KHSocialPlugin.prototype.FBAuthorize = function(config) {
		cordova.exec(null, null, "KHSocialPlugin", "FBAuthorize", []);
	};
 
    KHSocialPlugin.prototype.FBGetLoginStatus = function(cb, fail) {
        cordova.exec(cb, fail, "KHSocialPlugin", "FBGetLoginStatus", []);
    }
 
    KHSocialPlugin.prototype.FBPostToUserTimeline = function(textToShare, imageUrl, linkUrl) {
        cordova.exec(null, null, "KHSocialPlugin", "FBPostToUserTimeline", [textToShare, imageUrl, linkUrl]);
    }
 
	if(!window.plugins) window.plugins = {};
	window.plugins.KHSocialPlugin = new KHSocialPlugin();

})(window.cordova || window.Cordova || window.PhoneGap);
