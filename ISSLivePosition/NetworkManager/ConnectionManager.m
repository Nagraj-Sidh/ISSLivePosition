//
//  ConnectionManager.m
//  ISSLivePosition
//
//  Created by Nagraj on 2/25/23.
//

#import "ConnectionManager.h"
#import "ISSPosition.h"

#define KUrlString @"http://api.open-notify.org/iss-now.json"

@implementation ConnectionManager

- (void)retrieveISSPosition:(void(^)(ISSPosition * position, NSError * error))completionBlock {
    NSURL * dataURL = [NSURL URLWithString:KUrlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:dataURL];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError * errorObject = nil;
            ISSPosition * position = nil;
            
            if (error) {
                errorObject = error;
            } else  {
                NSError * jsonError = nil;
                NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                
                if (jsonError) {
                    errorObject = jsonError;
                } else {
                    if (jsonData[@"iss_position"] && jsonData[@"timestamp"]) {
                        NSDictionary * location = jsonData[@"iss_position"];
                        double latitude = [location[@"latitude"] doubleValue];
                        double longitude = [location[@"longitude"] doubleValue];
                        double timeStamp = [jsonData[@"timestamp"] doubleValue];
                        position = [[ISSPosition alloc] initWithLatitude:latitude longitude:longitude timeStamp:timeStamp];
                    } else {
                        NSString * errorMessage = [[jsonData objectForKey:@"status"] objectForKey:@"message"];
                        NSInteger errorCode = [[[jsonData objectForKey:@"status"] objectForKey:@"value"] integerValue];
                        NSDictionary * userInfo = [NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey];
                        errorObject = [NSError errorWithDomain:@"com.apple.ISSPosition" code:errorCode userInfo:userInfo];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock (position, errorObject);
                }
            });
        });
    }];
    
    [dataTask resume];
}

@end
