//
//  ISSPosition.h
//  ISSLivePosition
//
//  Created by Nagraj on 2/25/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ISSPosition : NSObject

#pragma mark - Creating and Initializing ISSPosition Model

/**
 Creates a new ISSPosition object with the below input parameters.
 
 @param latitude The ISS latitude
 @param longitude The ISS longitude
 @param timeStamp The timestamp the given location is valid
 @return The newly created ISSPosition object
 */
- (id)initWithLatitude:(double)latitude longitude:(double)longitude timeStamp:(double)timeStamp;

#pragma mark - Properties

/// Specifies the longitude
@property (nonatomic, assign) double longitude;

/// Specifies the latitude
@property (nonatomic, assign) double latitude;

/// Specifies the dateTime in string
@property (nonatomic, assign) double timeStamp;

@end

NS_ASSUME_NONNULL_END
