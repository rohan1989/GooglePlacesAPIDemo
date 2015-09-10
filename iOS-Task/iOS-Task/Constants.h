//
//  Constants.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#ifndef iOS_Task_Constants_h
#define iOS_Task_Constants_h
#endif

#pragma mark --------------------------------------------------------------
#pragma mark ENUMS
#pragma mark --------------------------------------------------------------
typedef NS_ENUM(int, PlaceType) {
    kPlaceType_Food = 1,
    kPlaceType_Gym,
    kPlaceType_School,
    kPlaceType_Hospital,
    kPlaceType_Spa,
    kPlaceType_Restaurent
};



#pragma mark --------------------------------------------------------------
#pragma mark Google API's
#pragma mark --------------------------------------------------------------
//#define GOOGLE_API_KEY @"AIzaSyDRA6K0XH29fLzBlrQz7TJLo8v3VfuKJfc"
//#define GOOGLE_API_KEY @"AIzaSyArOq-mX_nVoc71tl4GnmvMdboaEdRgpPg"
#define GOOGLE_API_KEY @"AIzaSyCPnBjJqjw0RxYNskuhVjf8ZsJ8TXGs7UA"


#define GOOGLE_MAPS_API @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
#define GOOGLE_MAPS_API_KEY_LOCATION @"location"
#define GOOGLE_MAPS_API_KEY_RADIUS @"radius"
#define GOOGLE_MAPS_API_KEY_TYPES @"types"
#define GOOGLE_MAPS_API_KEY @"key"

#define GOOGLE_MAP_IMAGE_API @"https://maps.googleapis.com/maps/api/place/photo?"
#define GOOGLE_MAP_IMAGE_API_KEY_MAXWIDTH @"maxwidth"
#define GOOGLE_MAP_IMAGE_API_KEY_PHOTO_REFERENCE @"photoreference"
#define GOOGLE_MAP_IMAGE_API_KEY @"key"