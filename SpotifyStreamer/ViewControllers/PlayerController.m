//
//  PlayerController.m
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/25/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//

#import "PlayerController.h"
#import <Spotify/SPTDiskCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlayerController () <SPTAudioStreamingDelegate>
@property (nonatomic, strong) SPTAudioStreamingController *player;
@end

@implementation PlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextSong:(id)sender {
    [self.player skipNext:nil];
}
- (IBAction)PausePlaySong:(id)sender {
    

    [self.player setIsPlaying:!self.player.isPlaying callback:nil];
    
}
- (IBAction)previousSong:(id)sender {
    [self.player skipPrevious:nil];
}



- (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur
                   withRadius: (CGFloat)blurRadius {
    
    CIImage *originalImage = [CIImage imageWithCGImage: imageToBlur.CGImage];
    CIFilter *filter = [CIFilter filterWithName: @"CIGaussianBlur"
                                  keysAndValues: kCIInputImageKey, originalImage,
                        @"inputRadius", @(blurRadius), nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef outImage = [context createCGImage: outputImage
                                        fromRect: [outputImage extent]];
    
    UIImage *ret = [UIImage imageWithCGImage: outImage];
    
    CGImageRelease(outImage);
    
    return ret;
}


-(void)PausePlayIcon {
    
}

-(void)updateUI {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (self.player.currentTrackURI == nil) {
        self.CoverImage.image = nil;
        return;
    }
    
    [SPTTrack trackWithURI:self.player.currentTrackURI
                   session:auth.session
                  callback:^(NSError *error, SPTTrack *track) {
                      
                      self.SongLabel.text = track.name;
                      self.AlbumLabel.text = track.album.name;
                      
                      SPTPartialArtist *artist = self.artist;
                      self.ArtistLabel.text = artist.name;
                      [self.CoverImage sd_setImageWithURL:track.album.largestCover.imageURL
                                        placeholderImage:[UIImage imageNamed:@"spinner.png"] ];
                      
                      [self.CoverImage sd_setImageWithURL:track.album.largestCover.imageURL placeholderImage:[UIImage imageNamed:@"spinner.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          self.CoverImage.image = image;
                          
                          //Fondo de pantalla del view
                          UIImage *blurred = [self applyBlurOnImage:image withRadius:10.0f];
                          UIGraphicsBeginImageContext(self.view.frame.size);
                          [blurred drawInRect:self.view.bounds];
                          UIImage *imageBackground = UIGraphicsGetImageFromCurrentImageContext();
                          UIGraphicsEndImageContext();
                          
                          self.view.backgroundColor = [UIColor colorWithPatternImage:imageBackground];
                          [self PausePlayButton];
                      }];
                      
                      
                      
                      
                      
                  }];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleNewSession];
}

-(void)handleNewSession {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (self.player == nil) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:auth.clientID];
        self.player.playbackDelegate = self;
        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
    }
    
    [self.player loginWithSession:auth.session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [self updateUI];
        [self.player playURIs:[SPTTrack urisFromArray:self.songs] fromIndex:(int)self.songIndex callback:nil];
                 
    }];
}

#pragma mark - Track Player Delegates

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didFailToPlayTrack:(NSURL *)trackUri {
    NSLog(@"failed to play track: %@", trackUri);
}

- (void) audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata {
    NSLog(@"track changed = %@", [trackMetadata valueForKey:SPTAudioStreamingMetadataTrackURI]);
    [self updateUI];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying {
    NSLog(@"is playing = %d", isPlaying);
    
    if(!isPlaying){
        [self.PausePlayButton setImage:[UIImage imageNamed:@"play-32.png"] forState:UIControlStateNormal];
    }else{
        [self.PausePlayButton setImage:[UIImage imageNamed:@"pause-32.png"] forState:UIControlStateNormal];
    }
}

@end
