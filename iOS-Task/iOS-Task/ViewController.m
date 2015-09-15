//
//  ViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 09/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "PlaceListViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *placeTypeArray;
    PlaceType selectedPlaceType;
    NSArray *searchedPlacesArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    placeTypeArray = [[NSArray alloc] initWithObjects:@"Food",@"Gym",@"School",@"Hospital",@"Spa",@"Restaurent", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self setHidesBottomBarWhenPushed:TRUE];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self setHidesBottomBarWhenPushed:FALSE];
    [super viewWillDisappear:animated];
}

#pragma mark --------------------------------------------------------------
#pragma mark Tableview Delegates and Datasources
#pragma mark --------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [placeTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"placeTypeCellIdentifier";
    UITableViewCell *_tableViewCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!_tableViewCell)
    {
        _tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [_tableViewCell setBackgroundColor:[UIColor clearColor]];
    }
    [_tableViewCell.textLabel setText:[placeTypeArray objectAtIndex:indexPath.row]];
    return _tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];

    AppDelegate *_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *_currentLocationArray = [_appDelegate getUserLocationDetails];
    
    if(!_currentLocationArray || ![_currentLocationArray count])
    {
//        return;
    }
    
    NSNumber *_usersLatitude = [NSNumber numberWithFloat:18.520430];//[_currentLocationArray objectAtIndex:0];
    NSNumber *_usersLongitude = [NSNumber numberWithFloat:73.856744];//[_currentLocationArray objectAtIndex:1];
    
    selectedPlaceType = (PlaceType)indexPath.row+1;
//  https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=18.520430,73.856744&radius=5000&types=FOOD&key=AIzaSyArOq-mX_nVoc71tl4GnmvMdboaEdRgpPg
    
    [[NetworkManager sharedNetworkManager] networkRequestWithURL:[NSString stringWithFormat:@"%@%@=%@&%@=%@&%@=%@&%@=%@", GOOGLE_MAPS_API, GOOGLE_MAPS_API_KEY_LOCATION, [NSString stringWithFormat:@"%f,%f", [_usersLatitude floatValue], [_usersLongitude floatValue]], GOOGLE_MAPS_API_KEY_RADIUS, @"50000", GOOGLE_MAPS_API_KEY_TYPES, [self getType:(int)indexPath.row], GOOGLE_MAPS_API_KEY, GOOGLE_API_KEY] WithCompletion:^(NSArray *placeResponseArray, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error && placeResponseArray && [placeResponseArray count])
            {
                searchedPlacesArray = nil;
                searchedPlacesArray = [[NSArray alloc] initWithArray:placeResponseArray];
                [self performSegueWithIdentifier:@"placesListSegueIdentifier" sender:self];
            }
        });
    }];
}

- (NSString *)getType:(int)_index
{
    switch (_index) {
        case 0:
            return @"FOOD";
            break;
        case 1:
            return @"GYM";
            break;
        case 2:
            return @"SCHOOL";
            break;
        case 3:
            return @"HOSPITAL";
            break;
        case 4:
            return @"SPA";
            break;
        case 5:
            return @"RESTAURENT";
            break;
        default:
            break;
    }
    return @"FOOD";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"placesListSegueIdentifier"])
    {
        PlaceListViewController *_placeListViewController = (PlaceListViewController *)segue.destinationViewController;
        _placeListViewController.hidesBottomBarWhenPushed = YES;
        [_placeListViewController initializeViewWithType:selectedPlaceType WithPlaces:searchedPlacesArray];
    }
}


@end
