//
//  PlaceDetailsViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 11/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import "MapViewController.h"

@interface PlaceDetailsViewController()
{
    Place *placeObject;
}

@end


@implementation PlaceDetailsViewController

- (void)populateDetailsWithPlace:(Place *)_place
{
    NSLog(@"populateDetailsWithPlace: %@", _place.placeName);
    placeObject = _place;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"mapViewSegueIdentifier"])
    {
        MapViewController *_mapViewController = (MapViewController *)segue.destinationViewController;
        _mapViewController.hidesBottomBarWhenPushed = YES;
        [_mapViewController showLocationWithLatitude:placeObject.latitude WithLongitude:placeObject.longitude];
    }
}


@end
