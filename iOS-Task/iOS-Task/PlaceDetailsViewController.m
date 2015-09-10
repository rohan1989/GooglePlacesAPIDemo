//
//  PlaceDetailsViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 11/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "PlaceDetailsViewController.h"

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

@end
