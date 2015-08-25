//
//  ArtistsViewController.m
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/11/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//

#import "ArtistController.h"
#import "SongController.h"
#import "ArtistCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Spotify/Spotify.h>
#import "Config.h"

@interface ArtistController ()
    @property (nonatomic,strong) NSMutableArray *artists;
    @property (nonatomic,strong) SPTUser *User;
   // @property (nonatomic,strong) NSMutableArray *artistsC;
    //@property (nonatomic,strong) UISearchController *searchController;
     //@property (nonatomic,strong) SPTArtist *artist;
@property (nonatomic,strong) UISearchController *searchController;

@end

@implementation ArtistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SPTAuth *auth = [SPTAuth defaultInstance];
    [SPTUser requestCurrentUserWithAccessToken:auth.session.accessToken callback:^(NSError *error, SPTUser *response) {
        if(error != nil){
            NSLog(@"*** Failed to get user %@", error);
            return;
        }
        self.User = response;
    }];
    
   //self.artists = [[Artist getArtists] mutableCopy];
    // Search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    // Add the search bar
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
   
    
    self.artists = [NSMutableArray array];
    
    // First load
    [self updateSearchResultsForSearchController:self.searchController];
   // [self updateSearchResultsForSearchController:];
    
        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // NSLog(@"COUNT ARTISTS: %lu", (unsigned long)self.artists.count);
    // Return the number of rows in the section.
    return self.artists.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];

    SPTPartialArtist* partialArtist = self.artists[indexPath.row];
    cell.nameLabel.highlightedTextColor = [UIColor colorWithRed:1 green:1 blue:0.898 alpha:1];
    cell.nameLabel.text = partialArtist.name;

    if (partialArtist.uri) {
        [SPTArtist artistWithURI:partialArtist.uri accessToken:nil callback:^(NSError *error, SPTArtist *artist) {
            if (artist.smallestImage.imageURL) {
                
                [cell.thumbnailImageView sd_setImageWithURL:artist.smallestImage.imageURL
                                  placeholderImage:[UIImage imageNamed:@"spinner.png"]];
                cell.thumbnailImageView.layer.cornerRadius = 31.0;
                cell.thumbnailImageView.layer.masksToBounds = YES;
            }
            
        }];
        
    }

    return cell;
}


#pragma mark - Search bar

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    //FORMA QUE FUNCIONA SIN IMAGENES
        [self.artists removeAllObjects];
    
    [SPTSearch performSearchWithQuery:self.searchController.searchBar.text queryType:SPTQueryTypeArtist accessToken: nil callback:^(NSError *error, SPTListPage *result) {
        
        for (SPTArtist *artist in result.items) {
            [self.artists addObject:artist];
        }
        
        
        [self.tableView reloadData];
        
    }];
    }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowSongs" sender:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowSongs"]) {
        
        
        NSIndexPath* indexPath = sender;
        SPTPartialArtist* artist = [self.artists objectAtIndex:indexPath.row];
        SongController *destViewController = segue.destinationViewController;
        destViewController.artist = artist;
        destViewController.User = self.User;
        
        
    }
}




/*
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    _artists = [_artists filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
