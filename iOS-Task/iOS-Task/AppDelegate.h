//
//  AppDelegate.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 09/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSArray *)getUserLocationDetails;

@end

