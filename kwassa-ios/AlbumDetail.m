//
//  AlbumDetail.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 11/17/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "AlbumDetail.h"

#import <Spotify/Spotify.h>
#include "AppDelegate.h"

#import "UIImageView+WebCache.h"

#import "MediaViewController.h"
#import "ReviewsServices.h"

@interface AlbumDetail ()

@end

@implementation AlbumDetail

SPTSession *session;
SPTAudioStreamingController *player;

SPTAlbum *sptAlbum;

NSMutableArray *tracks;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tracksTableView.delegate = self;
    self.tracksTableView.dataSource = self;
    
    tracks = [[NSMutableArray alloc] init];

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
                                           [self continueAlbumDetailSetup];
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

    NSLog(@"in continueAlbumDetailsSetup");
    
    if (sptAlbum.firstTrackPage != nil) {
        [tracks addObjectsFromArray:sptAlbum.firstTrackPage.items];
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
        [self setUpTableView];
    }

}

-(void)setUpTableView {
    NSString *url = self.coverUrl;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];

    self.artistAlbumLabel.text = [NSString stringWithFormat:@"%@ - %@", self.artist, self.album];
    self.scoreLabel.text = self.score;
    
    [self.tracksTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Track";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    SPTPartialTrack* track = [tracks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = track.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MediaViewController* mediaViewController = self.childViewControllers[0];
    
    //[mediaViewController playTrack:track.uri usingSession:session];
    [mediaViewController trackSelected:indexPath.row album:sptAlbum usingSession:session];
    
}

@end
