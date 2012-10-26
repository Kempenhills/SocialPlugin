//
//  KHSocialPlugin.js
//
// Created by Roy Derks on 26/10/12.
//
// Copyright 2012 Kempenhills ICT BV. All rights reserved.

(function(cordova) {

	function KHSocialPlugin() {}

	// Call this to register for push notifications and retreive a deviceToken
	KHSocialPlugin.prototype.registerDevice = function(config) {
		cordova.exec(null, null, "KHSocialPlugin", "FBAuthorize", []);
	};
	if(!window.plugins) window.plugins = {};
	window.plugins.KHSocialPlugin = new KHSocialPlugin();

})(window.cordova || window.Cordova || window.PhoneGap);
