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
    
    // populate albumReviews with dictionaries of album review info
    albumReviews = [reviewsServices getBestAlbumReviewsByYear:@"2010"];
    
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
    
    NSLog(@"exiting AlbumsCollectionViewController viewDidLoad");
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
    
    // I suspect bc collection view, indexPath.section might have to be taken into consideration for indexing into albumArtworkUrls
    // could probably do some maths. something index = row + section*10, if section is column
    NSString *url = albumArtworkUrls[indexPath.row];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    cell.albumArtwork.image = image;
    
    cell.artist.text = albumReviews[indexPath.row][@"artist"];
    
    return cell;
}

@end
