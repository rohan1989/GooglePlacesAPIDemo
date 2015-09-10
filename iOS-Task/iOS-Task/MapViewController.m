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
    float latitude, longitude;
}

@end


@implementation MapViewController

- (void)showLocationWithLatitude:(float)_latitude WithLongitude:(float)_longitude
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    latitude = _latitude;
    longitude = _longitude;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = latitude;
    zoomLocation.longitude= longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [mapView setRegion:viewRegion animated:YES];
}

@end
