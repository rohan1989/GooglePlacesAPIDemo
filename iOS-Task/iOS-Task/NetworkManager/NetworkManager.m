//
//  NetworkManager.m
//  iOS-Task
//
//  Created by Rohan Sonawane on 10/09/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "NetworkManager.h"
#import "PlaceParser.h"

@interface NetworkManager()<NSURLSessionDelegate>
{
    NSOperationQueue *networkOperationQueue;
}

@end


@implementation NetworkManager

+ (id)sharedNetworkManager
{
    static NetworkManager  *sharedNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedNetworkManager = [[self alloc]init];
    });
    return sharedNetworkManager;
}


- (void)networkRequestWithURL:(NSString *)_urlString WithCompletion:(void (^)(NSArray *placeResponseArray, NSError *error))completion
{
    NSLog(@"networkRequestWithURL: %@", _urlString);
    if(!networkOperationQueue)
    {
        networkOperationQueue = [[NSOperationQueue alloc] init];
    }
    
//    [networkOperationQueue addOperationWithBlock:^{
        NSURLSession *session = [NSURLSession sharedSession];
    [session invalidateAndCancel];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:_urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error || !data)
            {
                completion(nil, error);
            }
            else{
                NSDictionary *_responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"_responseDictionary: %@", _responseDictionary);
                
                PlaceParser *_placeParser = [[PlaceParser alloc] init];
                [_placeParser parserGooglePlacesWithDictionary:_responseDictionary WithCompletion:^(NSArray *placeResponseArray, NSError *error) {
                    completion(placeResponseArray, error);
                }];
            }
        }];
        [dataTask resume];
//    }];
}

- (void)networkRequestDownloadImage:(NSString *)_imageURL
{
    if(!networkOperationQueue)
    {
        networkOperationQueue = [[NSOperationQueue alloc] init];
        [networkOperationQueue setMaxConcurrentOperationCount:1];
    }
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:networkOperationQueue];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.tutsplus.com/mobile/uploads/2013/12/sample.jpg"]];
    [downloadTask resume];
}


#pragma mark --------------------------------------------------------------
#pragma mark URL Session Delgates
#pragma mark --------------------------------------------------------------
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSLog(@"data: %@", data);
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

@end
