//
//  AlbumDetail.h
//  kwassa-ios
//
//  Created by Andoni Mendoza on 11/17/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "ViewController.h"

@interface AlbumDetail : ViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSString* artist;
@property (weak, nonatomic) NSString* album;

@property (weak, nonatomic) IBOutlet UITableView *tracksTableView;


@end
