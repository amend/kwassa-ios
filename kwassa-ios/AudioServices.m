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

SPTSession *session;
SPTAudioStreamingController *player;

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

-(void)playTrack:(NSURL *)trackUri usingSession:(SPTSession *)session {
    
    NSLog(@"in AudioServices playTrack");
    
    // Create a new player if needed
    if (player == nil) {
        player = [SPTAudioStreamingController new];
    }
    
    [player loginWithSession:session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [SPTRequest requestItemAtURI:[NSURL URLWithString:[trackUri absoluteString]]
                         withSession:nil
                            callback:^(NSError *error, SPTAlbum *album) {
                                
                                if (error != nil) {
                                    NSLog(@"*** Album lookup got error %@", error);
                                    return;
                                }
                                [player playTrackProvider:album callback:nil];
                                
                                
                            }];
    }];
    
}

@end