//
//  PlaceListViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "PlaceListViewController.h"
#import "Place.h"

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
    }
}

@end
