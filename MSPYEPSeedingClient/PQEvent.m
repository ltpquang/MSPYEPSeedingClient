//
//  PQEvent.m
//  MSPYEPSeedingClient
//
//  Created by Le Thai Phuc Quang on 5/1/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "PQEvent.h"
#import <ParseOSX/ParseOSX.h>

@implementation PQEvent

- (void)uploadEventToServerWithBlock:(void(^)(BOOL succeeded, NSError *error))callBack {
    PFObject *eventObject = [PFObject objectWithClassName:@"Event"];
    eventObject[@"name"] = _name;
    eventObject[@"codeName"] = _codeName;
    eventObject[@"description"] = _eventDescription;
    eventObject[@"location"] = _location;
    eventObject[@"address"] = _address;
    eventObject[@"organizer"] = _organizer;
    eventObject[@"organizerLogo"] = _organizerLogo;
    eventObject[@"website"] = _website;
    eventObject[@"image"] = _image;
    
    [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        callBack(succeeded,error);
    }];

}

@end
