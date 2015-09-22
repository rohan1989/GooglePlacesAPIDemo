//
//  MapViewController.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 11/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController()<CLLocationManagerDelegate>
{
    __weak IBOutlet MKMapView *mapView;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    float latitude, longitude;
}

@end


@implementation MapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self getCurrentLocation];
}

- (void)getCurrentLocation
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [locationManager startUpdatingLocation];
        mapView.showsUserLocation = YES;
    }
}

- (void)showLocationWithLatitude:(float)_latitude WithLongitude:(float)_longitude
{
    latitude = _latitude;
    longitude = _longitude;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = latitude;
        zoomLocation.longitude= longitude;
        
        MKPointAnnotation *addAnnotation = [[MKPointAnnotation alloc] init];
        [addAnnotation setTitle:@"Test Annotation"];
        [addAnnotation setSubtitle:@"Test Annotation subtitle"];
        [addAnnotation setCoordinate:zoomLocation];
        [mapView addAnnotation:addAnnotation];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [mapView setRegion:viewRegion animated:YES];
    }
}

@end
