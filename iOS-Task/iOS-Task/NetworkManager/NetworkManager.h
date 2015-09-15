//
//  NetworkManager.h
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkManagerProtocol <NSObject>

- (void)imageDownloadComplete:(NSString *)_imageURL;

@end

@interface NetworkManager : NSObject

+ (id)sharedNetworkManager;
- (void)networkRequestWithURL:(NSString *)_urlString WithCompletion:(void (^)(NSArray *placeResponseArray, NSError *error))completion;
- (void)networkRequestDownloadImage:(NSString *)_imageURL WithDelegate:(id<NetworkManagerProtocol>)_networkManagerDelegate;

@end
