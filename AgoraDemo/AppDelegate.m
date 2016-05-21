//
//  AppDelegate.m
//  AgoraDemo
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 Agora. All rights reserved.
//

#import "AppDelegate.h"
#import "crasheye.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [Crasheye initWithAppKey:@"92ba4a35a6834810ba022f6bd76dc589s"];
    return YES;
}

@end
