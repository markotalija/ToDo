//
//  Task.m
//  ToDo
//
//  Created by Cubes School 6 on 5/16/16.
//  Copyright © 2016 Cubes School 6. All rights reserved.
//

#import "Task.h"

@implementation Task

#pragma mark - Public API

- (BOOL)isLocationValid {
    CLLocationDegrees latitude = [self.latitude floatValue];
    CLLocationDegrees longitude = [self.longitude floatValue];
    
    if (latitude == 0.0 || longitude == 0.0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    CLLocationDegrees latitude = [self.latitude floatValue];
    CLLocationDegrees longitude = [self.longitude floatValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSString *)title {
    return self.heading;
}

- (NSString *)subtitle {
    return self.desc;
}

@end
