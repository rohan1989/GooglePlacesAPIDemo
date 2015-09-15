//
//  AppDelegate.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 09/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#define USER_LOCATION_KEY_LATITUDE @"USER_LATITUDE"
#define USER_LOCATION_KEY_LONGITUDE @"USER_LONGITUDE"

#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self getCurrentLocation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark --------------------------------------------------------------
#pragma mark Location
#pragma mark --------------------------------------------------------------
- (void)getCurrentLocation
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];

    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        currentLocation = [locations objectAtIndex:0];
        NSLog(@"LOCATION %f %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        [self saveUsersLocation];
        [locationManager stopUpdatingLocation];
    }
}

- (void)saveUsersLocation
{
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    [_userDefaults setObject:[NSNumber numberWithFloat:currentLocation.coordinate.latitude] forKey:USER_LOCATION_KEY_LATITUDE];
    [_userDefaults setObject:[NSNumber numberWithFloat:currentLocation.coordinate.longitude] forKey:USER_LOCATION_KEY_LONGITUDE];
    [_userDefaults synchronize];
}

- (NSArray *)getUserLocationDetails
{
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    return [[NSArray alloc] initWithObjects:[_userDefaults objectForKey:USER_LOCATION_KEY_LATITUDE], [_userDefaults objectForKey:USER_LOCATION_KEY_LONGITUDE], nil];
}



@end
