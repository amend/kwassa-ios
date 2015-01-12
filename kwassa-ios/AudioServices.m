//
//  AudioServices.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 1/2/15.
//  Copyright (c) 2015 Andoni Mendoza. All rights reserved.
//

#import "AudioServices.h"

#import <Spotify/Spotify.h>
#include "AppDelegate.h"

@implementation AudioServices

SPTSession *sptSession;
SPTAudioStreamingController *player;

NSDate *prevLastPressed;

+ (AudioServices*)sharedInstance
{
    // 1
    static AudioServices *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AudioServices alloc] init];
    });
    return _sharedInstance;
}

-(void)playPauseTrack {
    NSLog(@"in AudioServices playPauseTrack");
    
    [player setIsPlaying:!player.isPlaying callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** setIsPlaying got error: %@", error);
            return;
        }
    }];
}

-(void)previousTrack {
    NSLog(@"in AudioServices previousTrack");
    
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [now timeIntervalSinceDate:prevLastPressed];
    prevLastPressed = [NSDate date];
    
    if(diff > 1) {
        NSLog(@"restarting track");
        [player seekToOffset:0 callback:^(NSError *error) {

            if (error != nil) {
                NSLog(@"*** previousTrack seekToOffset got error: %@", error);
                return;
            }

        }];
    } else {
        NSLog(@"skipping to previous track");
        
        [player skipPrevious:^(NSError *error) {
        
            if (error != nil) {
                NSLog(@"*** previousTrack skipPrevious got error: %@", error);
                return;
            }
        }];
    }
}

-(void)nextTrack {
    NSLog(@"in AudioServices nextTrack");
    
    [player skipNext:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** nextTrack got error: %@", error);
            return;
        }
        
    }];

}

-(void)trackSelected:(NSUInteger)trackNum album:(SPTAlbum *)album usingSession:(SPTSession *)session {
    NSLog(@"in AudioServices trackSelected");
    
    sptSession = session;
    prevLastPressed = [NSDate date];
    
    // Create a new player if needed
    if (player == nil) {
        player = [SPTAudioStreamingController new];
    }
    
    [player loginWithSession:session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [player playTrackProvider:album fromIndex:(int)trackNum callback:^(NSError *error) {
            
            if (error != nil) {
                NSLog(@"*** Enabling playback got error: %@", error);
                return;
            }
            
        }];
        
    }];
}

@end