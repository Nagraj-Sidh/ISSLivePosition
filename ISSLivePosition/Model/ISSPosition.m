//
//  ISSPosition.m
//  ISSLivePosition
//
//  Created by Nagraj on 2/25/23.
//

#import "ISSPosition.h"

@implementation ISSPosition

#pragma mark Designated initializer

- (id)initWithLatitude:(double)latitude longitude:(double)longitude timeStamp:(double)timeStamp {
    
    self = [super init];
    
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.timeStamp = timeStamp;
    }
    
    return self;
}

@end
