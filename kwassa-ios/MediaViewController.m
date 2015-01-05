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

- (IBAction)playSong:(id)sender {
    NSLog(@"in playSong, should play/pause");
}

- (void)playTrack:(NSURL *)trackUri usingSession:(SPTSession *)session {
    NSLog(@"in MediaViewController playTrack");
    
    [audioServices playTrack:trackUri usingSession:session];
}

@end
