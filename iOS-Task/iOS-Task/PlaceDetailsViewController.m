//
//  PlaceDetailsViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 11/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import "MapViewController.h"
#import "NetworkManager.h"
#import "ImageCache.h"
#import "DatabaseManager.h"

@interface PlaceDetailsViewController()<NetworkManagerProtocol>
{
    PlaceObject *placeObject;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *typesLabel;
    __weak IBOutlet UILabel *vicinityLabel;
    __weak IBOutlet UILabel *ratingsLabel;
    __weak IBOutlet UIImageView *placeImageView;
}

@end


@implementation PlaceDetailsViewController

- (void)populateDetailsWithPlace:(PlaceObject *)_place
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"populateDetailsWithPlace: %@", _place.placeName);
        placeObject = _place;
        
        [nameLabel setText:placeObject.placeName];
        
        NSMutableString *_string = [[NSMutableString alloc] initWithString:@"Types: "];
        if(![placeObject.typesArray count])
        {
            [_string appendString:@"NONE"];
        }
        else{
            for (NSString *typeString in placeObject.typesArray) {
                [_string appendString:[NSString stringWithFormat:@"%@, ", typeString]];
            }
        }
        [_string deleteCharactersInRange:NSMakeRange([_string length] - 2, 1)];
        [typesLabel setText:_string];
        
        
        [vicinityLabel setText:placeObject.vicinity];
        [ratingsLabel setText:[NSString stringWithFormat:@"RATINGS: %.2f", placeObject.rating]];
        
        if(placeObject.placeImageURL)
        {
            UIImage *_image = [[ImageCache sharedImageCache] getImageForKey:placeObject.placeImageURL];
            if(!_image)
            {
                [[NetworkManager sharedNetworkManager] networkRequestDownloadImage:placeObject.placeImageURL WithDelegate:self];
            }
            else{
                [placeImageView setImage:_image];
            }
        }
    });
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

#pragma mark --------------------------------------------------------------
#pragma mark Network Manager Delegate
#pragma mark --------------------------------------------------------------
- (void)imageDownloadComplete:(NSString *)_imageURL
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *_image = [[ImageCache sharedImageCache] getImageForKey:_imageURL];
        if(_image)
        {
            [placeImageView setImage:_image];
        }
    });
}

- (IBAction)addFavouritesButtonAction:(id)sender {
    [[DatabaseManager sharedDatabaseManager] saveFavourites:placeObject WithCompletion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *alertMessage = @"";
            NSString *alertTitle = @"";
            if(success && !error)
            {
                alertTitle = @"Added to favourites";
                alertMessage = @"Successfully added to favourites";
            }
            else if (success && error && error.code == 222)
            {
                alertTitle = @"Added to favourites";
                alertMessage = @"Already added to favourites";
            }
            else
            {
                alertTitle = @"Error";
                alertMessage = @"An error occurred while adding to favourites";
            }
            UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alertView show];
        });
    }];
}



@end
