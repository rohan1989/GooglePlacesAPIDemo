//
//  ImageCache.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 15/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCache : NSObject

+ (id)sharedImageCache;
- (void)storeImageWithKey:(NSString *)_imageKey WithImage:(NSData *)_imageData;
- (UIImage *)getImageForKey:(NSString *)_imageKey;

@end
