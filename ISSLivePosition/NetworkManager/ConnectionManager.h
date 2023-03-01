//
//  ConnectionManager.h
//  ISSLivePosition
//
//  Created by Nagraj on 2/25/23.
//

#import <Foundation/Foundation.h>
#import "ISSPosition.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConnectionManager : NSObject
/**
 Returns the ISS Position.
 
 @param completionBlock A block that is called returning the ISS position or error.
 */
- (void)retrieveISSPosition:(void(^)(ISSPosition * IssPosition, NSError * error))completionBlock;

@end

NS_ASSUME_NONNULL_END
