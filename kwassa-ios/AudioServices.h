//
//  AudioServices.h
//  kwassa-ios
//
//  Created by Andoni Mendoza on 1/2/15.
//  Copyright (c) 2015 Andoni Mendoza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Spotify/Spotify.h>

@interface AudioServices : NSObject

+(AudioServices*)sharedInstance;

-(void)playPauseTrack;

-(void)previousTrack;

-(void)nextTrack;

-(void)playTrack:(NSURL *)trackUri usingSession:(SPTSession *)session;

@end
