//
//  Place.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property(nonatomic, assign)float latitude;
@property(nonatomic, assign)float longitude;
@property(nonatomic, retain)NSString *iconURL;
@property(nonatomic, retain)NSString *placeID;
@property(nonatomic, retain)NSString *placeName;
@property(nonatomic, retain)NSString *reference;
@property(nonatomic, retain)NSArray *typesArray;
@property(nonatomic, retain)NSString *vicinity;
@property(nonatomic, assign)float rating;
@property(nonatomic, retain)NSString *placeImageURL;


@end
