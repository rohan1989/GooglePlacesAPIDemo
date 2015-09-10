//
//  PlaceParser.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceParser : NSObject

- (void)parserGooglePlacesWithDictionary:(NSDictionary *)_placeDictionary WithCompletion:(void (^)(NSArray *placeResponseArray, NSError *error))completion;

@end
