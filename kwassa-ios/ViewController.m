//
//  ViewController.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 10/7/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "ViewController.h"
#import <Spotify/Spotify.h>
#include "AppDelegate.h"
#include "ReviewsServices.h"

@interface ViewController ()

@property (strong, nonatomic) ReviewsServices *reviewsServices;

@end

@implementation ViewController

SPTSession *session;
SPTAudioStreamingController *player;
NSMutableArray *albumArtworks;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.reviewsServices = [[ReviewsServices alloc] init];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAny:(id)sender {

    if (session == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        session = appDelegate.session;
    }
    
    [self playUsingSession:session];
    
    // populate albumReviews with reviews dictionarys
    NSArray *albumReviews = [[self reviewsServices] getBestAlbumReviewsByYear:@"2010"];
    for (int i = 0; i < albumReviews.count; i++) {
        NSLog(@"albumReviews[i]: %@", albumReviews[i][@"artist"]);
    }
    
    // albumArtworks will contain albumArtwork for each review
    albumArtworks = [NSMutableArray array];
    for (int i = 0; i < albumReviews.count; i++) {
        NSString *imageUrl = albumReviews[i][@"images"][0][@"path"];
        imageUrl = [imageUrl substringFromIndex:5];
        imageUrl = [NSString stringWithFormat:@"%@%@", @"http://best-new-albums-artwork.s3-website-us-west-2.amazonaws.com/", imageUrl];
        NSLog(@"imageUrl: %@", imageUrl);
        [albumArtworks addObject:imageUrl];
    }
    
    
    
    NSLog(@"about to exist playAny!");
}

-(void)playUsingSession:(SPTSession *)session {
    
    // Create a new player if needed
    if (player == nil) {
        player = [SPTAudioStreamingController new];
    }
    
    [player loginWithSession:session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:4L1HDyfdGIkACuygktO7T7"]
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
