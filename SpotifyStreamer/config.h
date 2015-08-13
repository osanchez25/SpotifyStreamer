//
//  config.h
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/11/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//


#ifndef Simple_Track_Playback_Config_h
#define Simple_Track_Playback_Config_h


// For an in-depth auth demo, see the "Basic Auth" demo project supplied with the SDK.
// Don't forget to add your callback URL's prefix to the URL Types section in the target's Info pane!

// Your client ID
#define kClientId "44a5a136a35f469fb461a900bbf24d73"

// Your applications callback URL
#define kCallbackURL "spotifystreamer2512://callback"

// The URL to your token swap endpoint
// If you don't provide a token swap service url the login will use implicit grant tokens, which means that your user will need to sign in again every time the token expires.

// #define kTokenSwapServiceURL "http://localhost:1234/swap"

// The URL to your token refresh endpoint
// If you don't provide a token refresh service url, the user will need to sign in again every time their token expires.

// #define kTokenRefreshServiceURL "http://localhost:1234/refresh"


#define kSessionUserDefaultsKey "SpotifySession"

#endif

