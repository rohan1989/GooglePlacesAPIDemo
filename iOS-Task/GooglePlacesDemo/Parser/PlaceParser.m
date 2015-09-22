//
//  PlaceParser.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "PlaceParser.h"
#import "PlaceObject.h"
#import "Constants.h"

@implementation PlaceParser

- (void)parserGooglePlacesWithDictionary:(NSDictionary *)_placeDictionary WithCompletion:(void (^)(NSArray *placeResponseArray, NSError *error))completion
{
    NSString *status = [self objectForKeyOrNil:@"status" WithDictionary:_placeDictionary];
    if(status && [status isEqualToString:@"OK"])
    {
        NSArray *resultsArray = [self objectForKeyOrNil:@"results" WithDictionary:_placeDictionary];
        if(resultsArray && [resultsArray count])
        {
            NSMutableArray *parsedResponseArray = [[NSMutableArray alloc] init];
            for (NSDictionary *resultDictionary in resultsArray) {
                PlaceObject*_place = [[PlaceObject alloc] init];
                _place.latitude = [[self objectForKeyOrNil:@"lat" WithDictionary:[[resultDictionary objectForKey:@"geometry"] objectForKey:@"location"]] floatValue];
                _place.longitude = [[self objectForKeyOrNil:@"lng" WithDictionary:[[resultDictionary objectForKey:@"geometry"] objectForKey:@"location"]] floatValue];
                _place.iconURL = [self objectForKeyOrNil:@"icon" WithDictionary:resultDictionary];
                _place.placeID = [self objectForKeyOrNil:@"place_id" WithDictionary:resultDictionary];
                _place.placeName = [self objectForKeyOrNil:@"name" WithDictionary:resultDictionary];
                NSArray *_photosArray = [self objectForKeyOrNil:@"photos" WithDictionary:resultDictionary];
                if(_photosArray && [_photosArray isKindOfClass:[NSArray class]] && [_photosArray count])
                {
                    NSDictionary *_photoDictionary = [_photosArray objectAtIndex:0];
                    _place.reference = [self objectForKeyOrNil:@"photo_reference" WithDictionary:_photoDictionary];
                }
                
                NSArray *_typesArray = [self objectForKeyOrNil:@"types" WithDictionary:resultDictionary];
                if(_typesArray && [_typesArray count])
                {
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    for (NSString *_type in _typesArray) {
                        [tempArray addObject:_type];
                    }
                    _place.typesArray = [[NSArray alloc] initWithArray:tempArray];
                }
                
                _place.vicinity = [self objectForKeyOrNil:@"vicinity" WithDictionary:resultDictionary];
                _place.rating = [[self objectForKeyOrNil:@"rating" WithDictionary:resultDictionary] floatValue];
                
                if(_place.reference)
                {
                    _place.placeImageURL = [NSString stringWithFormat:@"%@%@=400&%@=%@&%@=%@", GOOGLE_MAP_IMAGE_API, GOOGLE_MAP_IMAGE_API_KEY_MAXWIDTH, GOOGLE_MAP_IMAGE_API_KEY_PHOTO_REFERENCE, _place.reference, GOOGLE_MAP_IMAGE_API_KEY, GOOGLE_API_KEY];
                }
                [parsedResponseArray addObject:_place];
            }
            completion(parsedResponseArray, nil);
        }
        else{
            completion(nil, [NSError errorWithDomain:@"Error Occurred" code:112 userInfo:_placeDictionary]);
        }
    }
    else
    {
        completion(nil, [NSError errorWithDomain:@"Error Occurred" code:111 userInfo:_placeDictionary]);
    }
}

- (id)objectForKeyOrNil:(id)key WithDictionary:(NSDictionary *)_dictionary{
    if(![[_dictionary allKeys] containsObject:key])
    {
        return @"";
    }
    id val = [_dictionary objectForKey:key];
    if (val ==[NSNull null])
    {
        return @"";
    }
    return val;
}

@end
