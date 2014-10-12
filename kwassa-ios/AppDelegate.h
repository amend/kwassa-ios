//
//  AppDelegate.h
//  kwassa-ios
//
//  Created by Andoni Mendoza on 10/7/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) SPTSession *session;

@property (nonatomic, strong) SPTAudioStreamingController *player;

@end

