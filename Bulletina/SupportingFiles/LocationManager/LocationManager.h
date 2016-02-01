//
//  LocationManager.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocation *currentLocation;

- (instancetype)init __attribute__((unavailable("Init not available, use sharedManager instead")));
+ (instancetype)new __attribute__((unavailable("Now not available, use sharedManager instead")));
+ (instancetype)alloc __attribute__((unavailable("Alloc not available, use sharedManager instead")));

+ (instancetype)sharedManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
