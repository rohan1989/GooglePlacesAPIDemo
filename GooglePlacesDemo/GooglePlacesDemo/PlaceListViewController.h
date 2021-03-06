//
//  PlaceListViewController.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface PlaceListViewController : UIViewController

- (void)initializeViewWithType:(PlaceType)_placeType WithPlaces:(NSArray *)_placesArray;

@end
