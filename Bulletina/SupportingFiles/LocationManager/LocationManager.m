//
//  LocationManager.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/21/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "LocationManager.h"

static CGFloat const MinimunDistance = 5.f;

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
        self.locationManager.distanceFilter = MinimunDistance;
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
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
