//
//  AppDelegate.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"IjcTgq7KqvJ98ihU6WWzmadFBpgn1ypK2bDZmiVy" clientKey:@"P4g1GPpjbBI2otjGBMzC6fP0Xsd7ySvoP8NN2V0j"];
    
//        PFObject *player = [PFObject objectWithClassName:@"Player"];
//        player[@"Name"] = @"John";
//        player[@"Score"] = @1230;
//        [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                NSLog(@"Object Uploaded");
//            }
//            else {
//                NSString *errorString =[[error userInfo] objectForKey:@"error"];
//                NSLog(@"Error: %@", errorString);
//            }
//        }];
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"Name" equalTo:@"John"];
    [query whereKey:@"Score" greaterThan:@1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects);
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
