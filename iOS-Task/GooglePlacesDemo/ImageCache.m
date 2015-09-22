//
//  ImageCache.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 15/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "ImageCache.h"

@interface ImageCache()
{
    NSCache *downloadedImageCache;
}

@end

@implementation ImageCache

+ (id)sharedImageCache
{
    static ImageCache  *sharedImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedImageCache = [[self alloc]init];
    });
    return sharedImageCache;
}


- (void)storeImageWithKey:(NSString *)_imageKey WithImage:(NSData *)_imageData
{
    if(!_imageKey || !_imageData || ![_imageKey length] || ![_imageData length])
    {
        return;
    }
    
    if(!downloadedImageCache)
    {
        downloadedImageCache = [[NSCache alloc] init];
    }
    
    [downloadedImageCache setObject:[[UIImage alloc] initWithData:_imageData] forKey:_imageKey];
}

- (UIImage *)getImageForKey:(NSString *)_imageKey
{
    return [downloadedImageCache objectForKey:_imageKey];
}


@end
