//
//  ReviewsServices.h
//  kwassa-ios
//
//  Created by Andoni Mendoza on 10/12/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewsServices : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *_responseData;

-(NSArray*) getBestAlbumReviewsByYear:(NSString*)year;

@end
