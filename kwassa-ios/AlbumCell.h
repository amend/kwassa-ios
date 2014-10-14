//
//  AlbumCell.h
//  kwassa-ios
//
//  Created by Andoni Mendoza on 10/13/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *artist;

@property (weak, nonatomic) IBOutlet UIImageView *albumArtwork;

@end
