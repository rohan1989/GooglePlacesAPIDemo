//
//  DatabaseManager.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 15/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Place.h"
#import "PlaceObject.h"

@interface DatabaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveFavourites:(PlaceObject *)_placeObject WithCompletion:(void (^)(BOOL success, NSError *error))completion;
- (void)getAllFavouritesWithCompletion:(void (^)(NSArray *_placesArray, NSError *error))completion;
+ (id)sharedDatabaseManager;

@end
