//
//  PlayerController.h
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/25/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface PlayerController : UIViewController<SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *CoverImage;
@property (weak, nonatomic) IBOutlet UILabel *SongLabel;
@property (weak, nonatomic) IBOutlet UILabel *ArtistLabel;
@property (nonatomic, strong) SPTPartialArtist *artist;
@property (nonatomic,strong) NSArray *songs;
@property (nonatomic,assign) NSInteger songIndex;
@property (weak, nonatomic) IBOutlet UILabel *AlbumLabel;
@property (weak, nonatomic) IBOutlet UIButton *PausePlayButton;


@end
