//
//  LocationManager.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "LocationManager.h"

static NSString *const TitleLocationServicesDisabled = @"Location Service Disabled";
static NSString *const MessageLocationServicesDisabled = @"To re-enable, please go to Settings and turn on Location Service for Bulletina.";

@interface LocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationManager

#pragma mark - Initializators

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyKilometer;
        self.locationManager.delegate = self;
		//temp
		#if TARGET_OS_SIMULATOR
		self.currentLocation = [[CLLocation alloc] initWithLatitude:48.618486232 longitude:22.298584669];	
		#else
		[self.locationManager requestWhenInUseAuthorization];
		#endif
    }
    return self;
}

#pragma mark - Static Methods

+ (instancetype)sharedManager
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super new];
    });
    return manager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            self.currentLocation = nil;
            break;
        }
        case kCLAuthorizationStatusNotDetermined: {
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            [self.locationManager startUpdatingLocation];
            break;
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.currentLocation = locations.firstObject;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //TODO: error handler
}

#pragma mark - Public Methods

- (void)startUpdatingLocation
{
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [[[UIAlertView alloc] initWithTitle:TitleLocationServicesDisabled
                                    message:MessageLocationServicesDisabled
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

@end
