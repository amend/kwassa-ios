//
//  AudioServices.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 1/2/15.
//  Copyright (c) 2015 Andoni Mendoza. All rights reserved.
//

#import "AudioServices.h"

@implementation AudioServices

+ (AudioServices*)sharedInstance
{
    // 1
    static AudioServices *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AudioServices alloc] init];
    });
    return _sharedInstance;
}

@end