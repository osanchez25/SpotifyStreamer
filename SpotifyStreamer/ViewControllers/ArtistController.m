//
//  ArtistsViewController.m
//  SpotifyStreamer
//
//  Created by Oscar Sanchez on 8/11/15.
//  Copyright (c) 2015 Oscar Sanchez. All rights reserved.
//

#import "ArtistController.h"
#import <Spotify/Spotify.h>
#import "Config.h"

@interface ArtistController ()
   // @property (nonatomic,strong) NSMutableArray *artists;
    //@property (nonatomic,strong) UISearchController *searchController;
     //@property (nonatomic,strong) SPTArtist *artist;

@end

@implementation ArtistController
{
    UISearchController *searchController;
    NSMutableArray *artists;
    
    NSInteger searchId;
    NSInteger displayedSearchId;
    NSUInteger loadedPage;
    NSUInteger nbPages;
    
    UIImage *placeholder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   //self.artists = [[Artist getArtists] mutableCopy];
    // Search controller
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.searchBar.delegate = self;
    
    // Add the search bar
    self.tableView.tableHeaderView = searchController.searchBar;
    self.definesPresentationContext = YES;
    [searchController.searchBar sizeToFit];
    
    
    artists = [NSMutableArray array];
    searchId = 0;
    displayedSearchId = -1;
    loadedPage = 0;
    nbPages = 0;
    
    placeholder = [UIImage imageNamed:@"white"];
    
    // First load
    [self updateSearchResultsForSearchController:searchController];
    
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

    // Return the number of rows in the section.
    return artists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];
    // Configure the cell...
    //SPTArtist* artist = self.artists[indexPath.row];
   // Artist *artist = self.artists[indexPath.row];
   // cell.nameLabel.text = artist.nombre;
    //cell.imageView.image = [UIImage imageNamed:artist.foto];
    
    
    
    SPTArtist *artist = artists[indexPath.row];
    //cell.textLabel.highlightedTextColor = [UIColor colorWithRed:1 green:1 blue:0.898 alpha:1];
    cell.textLabel.text = artist.name;
    
    // Avoid loading image that we don't need anymore
    //[cell.imageView cancelImageRequestOperation];
    // Load the image and display another image during the loading
    
    /*UIImage *image = nil;
    //NSData *imageData = [NSData dataWithContentsOfURL:artist.smallestImage.imageURL options:0 error:nil];
    
    if (imageData != nil) {
        image = [UIImage imageWithData:imageData];
    }
    cell.imageView.image = image;
    */
    return cell;
}


#pragma mark - Search bar

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    [artists removeAllObjects];
    
    [SPTSearch performSearchWithQuery:self->searchController.searchBar.text queryType:SPTQueryTypeArtist accessToken: nil callback:^(NSError *error, SPTListPage *result) {
        
        for (SPTArtist *artist in result.items) {
              [artists addObject:artist];
        }
        
        
        [self.tableView reloadData];
        
    }];
    
    
    
    /*query.fullTextQuery =
    NSInteger curSearchId = searchId;
    
    [movieIndex search:query success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *result) {
        if (curSearchId <= displayedSearchId) {
            return; // Newest query already displayed
        }
        
        displayedSearchId = curSearchId;
        loadedPage = 0; // Reset loaded page
        
        // Decode JSON
        NSArray *hits = result[@"hits"];
        nbPages = [result[@"nbPages"] integerValue];
        
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 0; i < [hits count]; ++i) {
            [tmp addObject:[[MovieRecord alloc] init:hits[i]]];
        }
        
        // Reload view with the new data
        
    } failure:nil];
    
    ++searchId;
     
     */
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
