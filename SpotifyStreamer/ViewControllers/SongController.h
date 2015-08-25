//
//  SongController.h
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/24/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface SongController : UITableViewController

@property (nonatomic, strong) SPTPartialArtist *artist;
@property (nonatomic,strong) SPTUser *User;

@end
