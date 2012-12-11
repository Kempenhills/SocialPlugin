/**
 * 
 * Cordova social plugin for Android
 * Created by KempenHills
 *
 */

package com.kempenhills;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;

public class SocialPlugin extends Plugin {

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {
		if(action.equals("FBPostToUserTimeline") || action.equals("TWTweetToUserTimeline") || action.equals("PresentActionSheet")) {
			try {
				JSONObject jso = new JSONObject(args.getString(0));
				doSendIntent("Subject", jso.getString("textToShare"));
				return new PluginResult(PluginResult.Status.OK);
			} catch (JSONException e) {
				return new PluginResult(PluginResult.Status.JSON_EXCEPTION);
			}
		} else {
			return new PluginResult(PluginResult.Status.INVALID_ACTION);
		}
	}
	
	private void doSendIntent(String subject, String text) {
		Intent sendIntent = new Intent(android.content.Intent.ACTION_SEND);
		sendIntent.setType("text/plain");
		sendIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);
		sendIntent.putExtra(android.content.Intent.EXTRA_TEXT, text);
		this.cordova.startActivityForResult(this, Intent.createChooser(sendIntent, null), 0);
	}

}
