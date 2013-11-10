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
#import "MotionVideoPlayer.h"
#import "Constants.h"

@interface AppDelegate ()

@property (strong, nonatomic) MotionVideoPlayer *player;
@property (assign, nonatomic) BOOL playerIsHere;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    [self showFonts];
	[self initModels];
    self.window.rootViewController.view.backgroundColor = [UIColor backgroundColor];
    [self initBackgroundVideo];

    return YES;
}

// CUSTOM METHODS FOR PICASSO

- (void)showFonts {
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);

        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (void)initModels {
	[[[DataManager sharedInstance] getGameModel] init];
}

- (void)initBackgroundVideo {
	self.player = [MotionVideoPlayer sharedInstance];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self.player loadURL:url];
    self.player.player.rate = 2.0;
//    self.player.player.volume = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendVideoPlayerToBack) name:[MPPEvents SendPlayerToBackEvent] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerHasMoved) name:[MPPEvents PlayerHasMovedEvent] object:nil];
	[self sendVideoPlayerToBack];
    self.window.rootViewController.view.backgroundColor = [UIColor backgroundColor];
}

- (void)sendVideoPlayerToBack {
    if(self.playerIsHere) return;
    else {
        self.playerIsHere = YES;
	    [self.window.rootViewController.view addSubview:self.player.view];
        [self.window.rootViewController.view sendSubviewToBack:self.player.view];
    }
}

- (void)videoPlayerHasMoved {
    self.playerIsHere = NO;
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
