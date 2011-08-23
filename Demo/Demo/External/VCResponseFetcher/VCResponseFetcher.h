//
//  VCResponseFetcher.h
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Main Service
#import "VCResponseFetchService.h"
#import "VCDataProcessorDelegate.h"
#import "VCResponseFetchServiceDelegate.h"

@interface VCResponseFetcher : NSObject {
@private
    NSOperationQueue *_networkOperationQueue;
	NSOperationQueue *_localOperationQueue;
}

+(VCResponseFetcher*)sharedInstance;

- (void)addObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer
				url:(NSString*)url
			  cache:(NSURLRequestCachePolicy)cache
  responseProcessor:(NSObject<VCDataProcessorDelegate>*)processor;

- (void)removeObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer;

@end
