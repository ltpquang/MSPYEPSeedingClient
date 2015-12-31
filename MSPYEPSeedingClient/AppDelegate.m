//
//  AppDelegate.m
//  MSPYEPSeedingClient
//
//  Created by Le Thai Phuc Quang on 4/29/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "AppDelegate.h"
#import <ParseOSX/ParseOSX.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/OSX
    //[Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"jhi4AwCRuUBS8JR1WrBQQKvX5ovzNWBSWGuHa7cW"
                  clientKey:@"PfFFsbbgSHVLIVKbwIW2TEQGOTcAjtRTDw2FX1rf"];
    
    // [Optional] Track statistics around application opens.
    //[PFAnalytics trackAppOpenedWithLaunchOptions:nil];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
