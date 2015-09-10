//
//  PlaceListViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "PlaceListViewController.h"
#import "Place.h"
#import "PlaceDetailsViewController.h"

@interface PlaceListViewController()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *placesArray;
    __weak IBOutlet UITableView *placesTableView;
    int selectedIndex;
}
@end

@implementation PlaceListViewController

- (void)initializeView:(BOOL)_isShownForTabBar WithType:(PlaceType)_placeType WithPlaces:(NSArray *)_placesArray
{
    if(!_isShownForTabBar)
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
        [placesTableView reloadData];
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
    }
    Place *_place = [placesArray objectAtIndex:indexPath.row];
    NSLog(@"PLACE: %@", _place.placeImageURL);
    [_tableViewCell.textLabel setText:_place.placeName];
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
        [_placeDetailsViewController populateDetailsWithPlace:[placesArray objectAtIndex:selectedIndex]];
    }
}

@end
