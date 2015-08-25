//
//  ArtistsCell.h
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/24/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@end
