//
//  Place.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 15/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) NSString * placeID;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) id typesArray;
@property (nonatomic, retain) NSString * vicinity;
@property (nonatomic) float rating;
@property (nonatomic, retain) NSString * placeImageURL;

@end
