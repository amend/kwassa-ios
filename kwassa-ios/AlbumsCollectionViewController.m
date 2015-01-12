//
//  AlbumsCollectionViewController.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 10/13/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "AlbumsCollectionViewController.h"
#import "AlbumCell.h"
#import "ReviewsServices.h"
#import <Spotify/Spotify.h>
#include "AppDelegate.h"

#import "SDWebImage/UIImageView+WebCache.h"
#import "AlbumDetail.h"

@interface AlbumsCollectionViewController ()

@end

SPTSession *session;
SPTAudioStreamingController *player;

ReviewsServices *reviewsServices;

NSArray *albumReviews;
NSArray *albumArtworkUrls;

@implementation AlbumsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    reviewsServices = [[ReviewsServices alloc] init];
    
    [self setReviewInfo:@"2014"];

}

- (BOOL)setReviewInfo:(NSString*) year {
    // populate albumReviews with dictionaries of album review info
    albumReviews = [reviewsServices getBestAlbumReviewsByYear:year];
    
    // populate albumArtworkUrls with aws s3 link to image
    NSMutableArray *albumArtworksM = [NSMutableArray array];
    for (int i = 0; i < albumReviews.count; i++) {
        NSString *imageUrl = albumReviews[i][@"images"][0][@"path"];
        // because scraper added "full/" at begging of every hash.jpg
        imageUrl = [imageUrl substringFromIndex:5];
        imageUrl = [NSString stringWithFormat:@"%@%@", @"http://best-new-albums-artwork.s3-website-us-west-2.amazonaws.com/", imageUrl];
        [albumArtworksM addObject:imageUrl];
    }
    albumArtworkUrls = [albumArtworksM copy];
    
    return true;
}

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return albumReviews.count;
}

// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ALBUM_CELL" forIndexPath:indexPath];
    
    // Here we use the provided setImageWithURL: method to load the web image (from SDWebImage, async and cache)
    NSString *url = albumArtworkUrls[indexPath.row];
    [cell.albumArtwork sd_setImageWithURL:[NSURL URLWithString:url]];
    
    cell.artist.text = albumReviews[indexPath.row][@"artist"];
    cell.album.text = albumReviews[indexPath.row][@"album"];
    cell.score.text = albumReviews[indexPath.row][@"score"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showAlbumDetail"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        AlbumDetail *albumDetail = [segue destinationViewController];
        albumDetail.artist = albumReviews[indexPath.row][@"artist"];
        albumDetail.album = albumReviews[indexPath.row][@"album"];
        albumDetail.score = albumReviews[indexPath.row][@"score"];
        albumDetail.coverUrl = albumArtworkUrls[indexPath.row];
    }
}

-(void)playAlbum:(NSURL *)albumUri usingSession:(SPTSession *)session {
    // Create a new player if needed
    if (player == nil) {
        player = [SPTAudioStreamingController new];
    }
    
    [player loginWithSession:session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [SPTRequest requestItemAtURI:[NSURL URLWithString:[albumUri absoluteString]]
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

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {

}

@end
