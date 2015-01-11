//
//  MediaViewController.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 12/28/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "MediaViewController.h"
#import "AudioServices.h"

@interface MediaViewController ()

@end

@implementation MediaViewController

AudioServices* audioServices;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    audioServices = [AudioServices sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playPauseTrackButton:(id)sender {
    NSLog(@"in playSong, should play/pause");
    
    [audioServices playPauseTrack];
}

- (IBAction)previousTrackButton:(id)sender {
    NSLog(@"in previousSongButton, should play previous track");
    // check if prev track exists
    
    [audioServices previousTrack];
}

- (IBAction)nextTrackButton:(id)sender {
    NSLog(@"in nextSongButton, should play next track");
    // play first track if last track
    
    [audioServices nextTrack];
}

- (void)trackSelected:(NSUInteger)trackNum album:(SPTAlbum *)album  usingSession:(SPTSession *)session {
    NSLog(@"in MediaViewController playTrack");
    
    [audioServices trackSelected:trackNum album:album usingSession:session];
}

@end
