//
//  AppDelegate.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "GalleryViewController.h"
#import "Colors.h"
#import "MotionVideoPlayer.h"
#import "OrientationUtils.h"

@interface AppDelegate ()

@property (strong, nonatomic) MotionVideoPlayer *player;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController.view.backgroundColor = [UIColor backgroundColor];

    [self initModels];
//    [self showFonts];
    [self initBackgroundVideo];
    
    return YES;
}

// CUSTOM METHODS FOR PICASSO

- (void)initModels {
    [[DataManager sharedInstance] getGameModel]; // Implicitly load the game
}

- (void)showFonts {
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"--%@--", family);

        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (void)initBackgroundVideo {
	self.player = [MotionVideoPlayer sharedInstance];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self.player loadURL:url];
    self.player.player.rate = 2.0;
    self.player.player.volume = 0;
    
    self.window.rootViewController.view.backgroundColor = [UIColor backgroundColor];
    
//    [self.window.rootViewController.view addSubview:self.player.view];
//    [self.window.rootViewController.view sendSubviewToBack:self.player.view];
}

- (void)initMenuButton {

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[[DataManager sharedInstance] getGameModel] save]; // Save game progress
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
