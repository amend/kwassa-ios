//
//  ReviewsServices.m
//  kwassa-ios
//
//  Created by Andoni Mendoza on 10/12/14.
//  Copyright (c) 2014 Andoni Mendoza. All rights reserved.
//

#import "ReviewsServices.h"

@implementation ReviewsServices

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self._responseData = [[NSMutableData alloc] init];
    
    NSLog(@"in didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self._responseData appendData:data];
    
    NSLog(@"in didReceiveData");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSString *strData = [[NSString alloc]initWithData:self._responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"in connectionDidFinishLoading, _responseData: %@", strData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    NSLog(@"in didFailWithError: " );
}

// 54.191.36.11/bestalbums/byyear/2004/
-(NSArray*) getBestAlbumReviewsByYear:(NSString*)year {
    NSString* path = [@"/bestalbums/byyear/" stringByAppendingString:year];
    path = [path stringByAppendingString:@"/"];
    NSString* urlStr = @"http://54.191.36.11";
    
    urlStr = [urlStr stringByAppendingString:path];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // construct request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //setting prarameters of the GET connection
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"en-US" forHTTPHeaderField:@"Content-Language"];
    [request setTimeoutInterval:20.0];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *dataReceived = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *jsonRes = [NSJSONSerialization JSONObjectWithData:dataReceived options:kNilOptions error:&error];
    if (error != nil) { NSLog(@"Error parsing JSON!");}

    if (jsonRes[@"success"]) {
        NSArray* results = jsonRes[@"albums"];
        NSMutableArray *albumReviewsM = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < results.count; i++) {
            NSDictionary *review =
            [NSJSONSerialization JSONObjectWithData: [results[i] dataUsingEncoding:NSUTF8StringEncoding]
                                            options: NSJSONReadingMutableContainers
                                              error: &error];
            if (error != nil) { NSLog(@"Error parsing JSON!");}
            
            [albumReviewsM addObject:review];
        }

        return [albumReviewsM copy];
    } else {
        NSLog(@"error in getBestAlbumReviewsByYear");
        return nil;
    }
}

@end
