//
//  MediaViewController.h
//  kwassa-ios
//
//  Created by Andoni Mendoza on 12/28/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface MediaViewController : UIViewController

- (IBAction)playPauseTrackButton:(id)sender;

- (IBAction)previousTrackButton:(id)sender;

- (IBAction)nextTrackButton:(id)sender;

- (void)playTrack:(NSURL *)trackUri usingSession:(SPTSession *)session;

@end
