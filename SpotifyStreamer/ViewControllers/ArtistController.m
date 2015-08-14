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
    @property (nonatomic,strong) NSMutableArray *artists;
    @property (nonatomic,strong) NSMutableArray *artistsC;
    //@property (nonatomic,strong) UISearchController *searchController;
     //@property (nonatomic,strong) SPTArtist *artist;
@property (nonatomic,strong) UISearchController *searchController;

@end

@implementation ArtistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    /*searchId = 0;
    displayedSearchId = -1;
    loadedPage = 0;
    nbPages = 0;
    
    placeholder = [UIImage imageNamed:@"white"];
    */
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
   NSLog(@"COUNT ARTISTS: %lu", (unsigned long)self.artists.count);
    // Return the number of rows in the section.
    return self.artists.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];

    // Configure the cell...
    //SPTArtist* artist = self.artists[indexPath.row];
   // Artist *artist = self.artists[indexPath.row];
   // cell.nameLabel.text = artist.nombre;
    //cell.imageView.image = [UIImage imageNamed:artist.foto];
    
    
    
    SPTPartialArtist* partialArtist = self.artists[indexPath.row];
    //cell.textLabel.highlightedTextColor = [UIColor colorWithRed:1 green:1 blue:0.898 alpha:1];
    cell.textLabel.text = partialArtist.name;
    
    // Avoid loading image that we don't need anymore
    //[cell.imageView cancelImageRequestOperation];
    // Load the image and display another image during the loading
    
    
    if (partialArtist.uri) {
        [SPTArtist artistWithURI:partialArtist.uri accessToken:nil callback:^(NSError *error, SPTArtist *artist) {
            if (artist.smallestImage.imageURL) {
                // Pop over to a background queue to load the image over the network.
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error = nil;
                    UIImage *image = nil;
                    NSData *imageData = [NSData dataWithContentsOfURL:artist.smallestImage.imageURL options:0 error:nil];
                    
                    if (imageData != nil) {
                        image = [UIImage imageWithData:imageData];
                    }
                    
                    
                    // …and back to the main queue to display the image.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.imageView.image = image;
                        if (image == nil) {
                            NSLog(@"Couldn't load cover image with error: %@", error);
                            return;
                        }
                    });
                    
                    
                });            }
            
        }];
    
    }
    
    NSLog(@"Retornando CELL %@", @"");
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
    
    
    //if (self.searchController.searchBar.text.length > 3) {
    
        //
    
    
   /// PARTE RARA
    
    
    /*
        SPTAuth *auth = [SPTAuth defaultInstance];

 NSLog(@"TEXTO BSUQUEDA %@ ", self.searchController.searchBar.text);
    
    
    [self.artists removeAllObjects];

        [SPTSearch performSearchWithQuery:self.searchController.searchBar.text queryType:SPTQueryTypeArtist accessToken: auth.session.accessToken callback:^(NSError *error, SPTListPage *result) {
            NSLog(@"OBTENIDO %lu ", (unsigned long)result.items.count);
                       for (SPTPartialArtist *PartialArtist in result.items) {
                
               
                if (PartialArtist.uri) {
                   
                    [SPTArtist artistWithURI:PartialArtist.uri accessToken:nil callback:^(NSError *error, SPTArtist *artist) {
                       // if (artist != nil) {
                         NSLog(@"AGREGADO %@ ", artist.name);
                            [self.artists addObject:artist];
                       
                       // }else{
                       // NSLog(@"NOT OBJECt %@ ", @"");
                       // }
                                            }];
                }else{
                NSLog(@"NOT URI %@ ", PartialArtist.name);
                }
              
                
            }
            //self.artists = self.artistsC;
            
           [self.tableView reloadData];
            
        }];
    */
}
    /*
    
    }
    
  
    */
    /*
     
     
    
    // Oh noes, the token has expired, if we have a token refresh service set up, we'll call tat one.
    
    
    [SPTSearch performSearchWithQuery:self.searchController.searchBar.text queryType:SPTQueryTypeArtist accessToken: nil callback:^(NSError *error, SPTListPage *result) {
        [self.artists removeAllObjects];
        
        
        for (SPTPartialArtist *PartialArtist in result.items) {
           // [self.artistsURI addObjectsFromArray:result.items.accessibilityElements]
            
            [SPTArtist artistWithURI:PartialArtist.uri session:auth.session callback:^(NSError *error, SPTArtist *artist) {
                [self.artists addObject:artist];
            }];
            
        }
        [self.tableView reloadData];
  }];
        */
      //  NSArray *names = [result.items valueForKey:@"playableUri"];
       // for (NSURL *objeto in result) {
         
            //[self.artists addObject:artist];
       // }
        
        
        
        
         /*NSArray *names = [result.items valueForKey:@"playableUri"];
        [SPTArtist artistsWithURIs:names session:nil callback:^(NSError *error, NSArray *ArtistList) {
            [self.artists removeAllObjects];
            [self.artists addObjectsFromArray:ArtistList];
        }];
        
        
        
        
        
        
       //[a]SPTArtist createRequestForArtists:result.items withAccessToken:nil error:(NSError *__autoreleasing *)
        
        
         
         for (NSURL *objeto in names) {
         [self.artists addObject:artist];
         }
         for (SPTPartialArtist *artist in result.items) {
            [self.artistsURI addObjectsFromArray:result.items.accessibilityElements]
            
            SPTArtist artistsWithURIs:result.items session:<#(SPTSession *)#> callback:<#^(NSError *error, id object)block#>
              [self.artists addObject:artist];
        }
         [SPTArtist artistsWithURIs:names session:nil callback:^(NSError *error, SPTListPage *ArtistList) {
         
         [self.artists addObjectsFromArray:ArtistList.items];
         }];
       
        */
        
  
    
    
    
    





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
