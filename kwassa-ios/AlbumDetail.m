//
//  AlbumDetail.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 11/17/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "AlbumDetail.h"

#import "ReviewsServices.h"
#import <Spotify/Spotify.h>
#include "AppDelegate.h"


@interface AlbumDetail ()

@end

@implementation AlbumDetail

SPTSession *session;
SPTAudioStreamingController *player;

SPTAlbum *sptAlbum;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSLog(@"AlbumDetail for artist: %@", self.artist);
    NSLog(@"AlbumDetail for album: %@", self.album);
    
     if (session == nil) {
         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         session = appDelegate.session;
     }
     
     [SPTRequest performSearchWithQuery:self.album
                              queryType:SPTQueryTypeAlbum
                                 offset:0 session:session
                               callback:^(NSError *error, SPTListPage *listPage) {
                                   
                                   if(error != nil ) {
                                       NSLog(@"error in spt request callback");
                                   }
     
                                   if (listPage.totalListLength > 0) {
                                       [SPTRequest requestItemFromPartialObject:listPage.items[0] withSession:session callback:^(NSError *error, SPTAlbum *album) {

                                           if(error != nil ) {
                                               NSLog(@"error in spt request callback");
                                           }
                                           
                                           sptAlbum = album;
                                           //[self continueAlbumDetailSetup];
                                       }];
                                   }
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// bc the pyramid of callbacks can get gnarly
- (void)continueAlbumDetailSetup {
    // firstTrackPage is tracks contained by this album, as a page of SPTPartialTrack objects
    // in one of the elses, call function that sorts tracks by tracknumber, and then set up table view and everything else
    
    // this will probably need to be debugged...
    
    if (sptAlbum.firstTrackPage != nil) {
        [self getTracksFromSPTListPage:sptAlbum.firstTrackPage];
    } else {
        NSLog(@"firstTrackPage was nil!");
    }
    
    if (sptAlbum.firstTrackPage.hasNextPage) {
        [sptAlbum.firstTrackPage requestNextPageWithSession:session callback:^(NSError *error, SPTAlbum *partialAlbum) {
            sptAlbum = partialAlbum;
            [self continueAlbumDetailSetup];
        }];
    } else {
        NSLog(@"did not have nextPage");
    }
    
    NSLog(@"in continueAlbumDetailsSetup");
}

// now add name, playable uri, and tracknumber to tracks
// another function will sort on tracknumber when no more pages
- (void)getTracksFromSPTListPage:(SPTListPage*) page {
    NSLog(@"going to extract tracks");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
