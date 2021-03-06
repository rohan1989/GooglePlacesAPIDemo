//
//  DatabaseManager.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 15/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

+ (id)sharedDatabaseManager
{
    static DatabaseManager  *sharedDatabaseManagers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedDatabaseManagers = [[self alloc]init];
    });
    return sharedDatabaseManagers;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.iOS_Task" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iOS_Task" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iOS_Task.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)saveFavourites:(PlaceObject *)_placeObject WithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"placeID = %@", _placeObject.placeID];
    NSError *executeFetchError = nil;
    NSArray *results = [context executeFetchRequest:request error:&executeFetchError];
    
    if (executeFetchError) {
        completion(FALSE, executeFetchError);
        NSLog(@"executeFetchError: %@", executeFetchError);
    } else if (!results || ![results count]) {
        Place *_place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        _place.latitude = _placeObject.latitude;
        _place.longitude = _placeObject.longitude;
        _place.iconURL = _placeObject.iconURL;
        _place.placeID = _placeObject.placeID;
        _place.placeName = _placeObject.placeName;
        _place.reference = _placeObject.reference;
        _place.typesArray = [NSKeyedArchiver archivedDataWithRootObject:_placeObject.typesArray];
        _place.vicinity = _placeObject.vicinity;
        _place.rating = _placeObject.rating;
        _place.placeImageURL = _placeObject.placeImageURL;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            completion(FALSE, error);
        }
        else{
            completion(TRUE, nil);
        }
    }
    else if ([results count])
    {
        completion(TRUE, [NSError errorWithDomain:@"Saved" code:222 userInfo:@{@"Reason": @"data already exists"}]);
    }
}


- (void)getAllFavouritesWithCompletion:(void (^)(NSArray *_placesArray, NSError *error))completion
{
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *_placesArray = [[NSMutableArray alloc] init];
    for (Place *_placeObject in fetchedObjects) {

        PlaceObject *_place = [[PlaceObject alloc] init];
        _place.latitude = _placeObject.latitude;
        _place.longitude = _placeObject.longitude;
        _place.iconURL = _placeObject.iconURL;
        _place.placeID = _placeObject.placeID;
        _place.placeName = _placeObject.placeName;
        _place.reference = _placeObject.reference;
        _place.typesArray = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:_placeObject.typesArray];
        _place.vicinity = _placeObject.vicinity;
        _place.rating = _placeObject.rating;
        _place.placeImageURL = _placeObject.placeImageURL;

        NSLog(@"NAME: %@", _place.placeName);
        [_placesArray addObject:_place];
    }
    
    completion([_placesArray count]?_placesArray:nil, [_placesArray count]?nil:[NSError errorWithDomain:@"Favourites" code:111 userInfo:@{@"Reason":@"Favourites list empty"}]);
}

@end
