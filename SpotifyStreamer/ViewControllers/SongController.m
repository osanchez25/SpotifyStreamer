//
//  SongController.m
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/24/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//

#import "SongController.h"
#import <Spotify/Spotify.h>
#import "SongCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlayerController.h"

@interface SongController ()
@property (nonatomic,strong) NSMutableArray *songs;
@end

@implementation SongController

- (void)viewDidLoad {
    [super viewDidLoad];

    SPTAuth *auth = [SPTAuth defaultInstance];
    
    NSURLRequest *topTracksReq = [SPTArtist createRequestForTopTracksForArtist:self.artist.uri withAccessToken:auth.session.accessToken  market:self.User.territory error:nil];
    
    
    [[SPTRequest sharedHandler] performRequest:topTracksReq callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        if (error != nil) {
            NSLog(@"*** Failed to get songs %@", error);
            return;
        }
         self.songs = [[NSMutableArray alloc] initWithArray:[SPTTrack tracksFromData:data withResponse:response error:nil]];
        [self.tableView reloadData];
             // [self.player playURIs:playlistSnapshot.firstTrackPage.items fromIndex:0 callback:nil];
    }];
     
    

    
    
    
    /*
    [SPTUser requestCurrentUserWithAccessToken:auth.session.tokenType callback:^(NSError *error, SPTUser *response) {
        self.User = response;
    }];
    
    NSURLRequest *trackToplistrequest = [SPTArtist createRequestForTopTracksForArtist:self.artist.uri withAccessToken:nil market:self.User.territory error:nil];
    
    [[SPTRequest sharedHandler] performRequest:trackToplistrequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        //if (error != nil) { Handle error }
        self.songs = [SPTTrack tracksFromData:data withResponse:response error:nil];
        
    }];
    */
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongCell" forIndexPath:indexPath];
    
    SPTPartialTrack* Track = self.songs[indexPath.row];
    //cell.textLabel.highlightedTextColor = [UIColor colorWithRed:1 green:1 blue:0.898 alpha:1];
    cell.nameLabel.text = Track.name;
    cell.AlbumLabel.text = Track.album.name;
               // [cell.thumbnailImageView cancelLoadingAllImages];
                //Load the new image
    
    [cell.thumbnailImageView sd_setImageWithURL:Track.album.smallestCover.imageURL
                      placeholderImage:[UIImage imageNamed:@"spinner.png"]];
    
    cell.thumbnailImageView.layer.cornerRadius = 31.0;
    cell.thumbnailImageView.layer.masksToBounds = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowPlayer" sender:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowPlayer"]) {
        //NSMutableArray *SongsUri ;
        ////for (SPTPartialTrack* track in self.songs) {
        //    [SongsUri addObject:track.playableUri];
        //}
        NSIndexPath *indexPath = sender;
        PlayerController *destViewController = segue.destinationViewController;
        destViewController.songs = self.songs;
        destViewController.songIndex = indexPath.row;
        destViewController.artist = self.artist;
        
        
    }
}



@end
