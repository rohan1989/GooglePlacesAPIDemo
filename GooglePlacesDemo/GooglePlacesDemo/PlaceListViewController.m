//
//  PlaceListViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "PlaceListViewController.h"
#import "PlaceObject.h"
#import "PlaceDetailsViewController.h"
#import "DatabaseManager.h"
#import "ImageCache.h"
#import "NetworkManager.h"

@interface PlaceListViewController()<UITableViewDataSource, UITableViewDelegate, NetworkManagerProtocol>
{
    NSArray *placesArray;
    __weak IBOutlet UITableView *placesTableView;
    int selectedIndex;
    BOOL isShownForTabBar;
}
@end

@implementation PlaceListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    if([self.navigationController.viewControllers count]>1)
    {
        isShownForTabBar = FALSE;
    }
    else
    {
        isShownForTabBar = TRUE;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(isShownForTabBar)
    {
        [[DatabaseManager sharedDatabaseManager] getAllFavouritesWithCompletion:^(NSArray *_placesArray, NSError *error) {
            if(_placesArray && [_placesArray count] && !error)
            {
                placesArray = nil;
                placesArray = [[NSArray alloc] initWithArray:_placesArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [placesTableView reloadData];
                });
            }
        }];
    }
}

- (void)initializeViewWithType:(PlaceType)_placeType WithPlaces:(NSArray *)_placesArray
{
    if(!isShownForTabBar)
    {
        NSString *navigationTitle = @"Places List";
        switch (_placeType) {
            case kPlaceType_Food:
                navigationTitle = @"Food's List";
                break;
            case kPlaceType_Gym:
                navigationTitle = @"Gym's List";
                break;
            case kPlaceType_Hospital:
                navigationTitle = @"Hospital's List";
                break;
            case kPlaceType_Restaurent:
                navigationTitle = @"Restaurent's List";
                break;
            case kPlaceType_School:
                navigationTitle = @"School's List";
                break;
            case kPlaceType_Spa:
                navigationTitle = @"Spa's List";
                break;
                
            default:
                break;
        }
        [self.navigationItem setTitle:navigationTitle];
        
        placesArray = [[NSArray alloc] initWithArray:_placesArray];
    }
}


#pragma mark --------------------------------------------------------------
#pragma mark Tableview Delegates and Datasources
#pragma mark --------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [placesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"placeListCellIdentifier";
    UITableViewCell *_tableViewCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!_tableViewCell)
    {
        _tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [_tableViewCell setBackgroundColor:[UIColor clearColor]];
        [_tableViewCell.textLabel setTextColor:[UIColor whiteColor]];
        [_tableViewCell.textLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:10.0f]];
    }
    PlaceObject *_place = [placesArray objectAtIndex:indexPath.row];
    NSLog(@"PLACE: %@", _place.placeImageURL);
    [_tableViewCell.textLabel setText:_place.placeName];
    
    if(_place.placeImageURL)
    {
        UIImage *_image = [[ImageCache sharedImageCache] getImageForKey:_place.placeImageURL];
        if(!_image)
        {
            [[NetworkManager sharedNetworkManager] networkRequestDownloadImage:_place.placeImageURL WithDelegate:self];
        }
        else{
            [_tableViewCell.imageView setImage:_image];
        }
    }
    
    return _tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    selectedIndex = (int)indexPath.row;
    [self performSegueWithIdentifier:@"placeDetailsSegueIdentifier" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"placeDetailsSegueIdentifier"])
    {
        PlaceDetailsViewController *_placeDetailsViewController = (PlaceDetailsViewController *)segue.destinationViewController;
        _placeDetailsViewController.hidesBottomBarWhenPushed = YES;
        [_placeDetailsViewController.view setClipsToBounds:TRUE];
        [_placeDetailsViewController populateDetailsWithPlace:[placesArray objectAtIndex:selectedIndex]];
    }
}

#pragma mark --------------------------------------------------------------
#pragma mark Network Manager Delegate
#pragma mark --------------------------------------------------------------
- (void)imageDownloadComplete:(NSString *)_imageURL
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [placesTableView reloadData];
    });
}

@end
