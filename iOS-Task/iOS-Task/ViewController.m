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

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *placeTypeArray;
    PlaceType selectedPlaceType;
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
    selectedPlaceType = (PlaceType)indexPath.row+1;
    [self performSegueWithIdentifier:@"placesListSegueIdentifier" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"placesListSegueIdentifier"])
    {
        PlaceListViewController *_placeListViewController = (PlaceListViewController *)segue.destinationViewController;
        _placeListViewController.hidesBottomBarWhenPushed = YES;
        [_placeListViewController initializeView:FALSE WithType:selectedPlaceType];
    }
}


@end
