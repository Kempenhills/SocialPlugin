package com.kempenhills.khsocialplugin;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class SocialPlugin extends CordovaPlugin {

	public static final String FB_AUTHORIZE = "FBAuthorize";
	public static final String FB_UNAUTHORIZE = "FBUnauthorize";
	public static final String FB_POSTTOUSERTIMELINE = "FBPostToUserTimeline";
	
	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		if(action.equalsIgnoreCase(FB_AUTHORIZE)) {
			
		} else if(action.equalsIgnoreCase(FB_UNAUTHORIZE)) {
			
		} else if(action.equalsIgnoreCase(FB_POSTTOUSERTIMELINE)) {
			
		}
		return false;
	}

}
