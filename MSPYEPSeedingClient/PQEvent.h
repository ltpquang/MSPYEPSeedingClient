//
//  PQEvent.h
//  MSPYEPSeedingClient
//
//  Created by Le Thai Phuc Quang on 5/1/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PQEvent : NSObject
@property NSString *name;
@property NSString *codeName;
@property NSString *eventDescription;
@property NSString *location;
@property NSString *address;
@property NSString *organizer;
@property NSString *organizerLogo;
@property NSString *website;
@property NSString *image;
@property NSDate *fromDate;
@property NSDate *toDate;

- (void)uploadEventToServerWithBlock:(void(^)(BOOL succeeded, NSError *error))callBack;
@end
