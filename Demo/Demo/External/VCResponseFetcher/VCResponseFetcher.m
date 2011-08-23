//
//  VCResponseFetcher.m
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCResponseFetcher.h"

@implementation VCResponseFetcher

- (id)init 
{
	self = [super init];
	if (self) 
	{
		_networkOperationQueue = [[NSOperationQueue alloc] init];
		[_networkOperationQueue setMaxConcurrentOperationCount:3];
		_localOperationQueue = [[NSOperationQueue alloc] init];
		
		[[NSURLCache sharedURLCache] setMemoryCapacity:1024*1024*4]; // 4 megabytes
		[[NSURLCache sharedURLCache] setDiskCapacity:1024*1024*50]; // 50 megabytes
	}
	return self;
}

- (void)dealloc 
{
	[_networkOperationQueue release], _networkOperationQueue = nil;
	[_localOperationQueue release], _localOperationQueue = nil;
	[super dealloc];
}

+(VCResponseFetcher*)sharedInstance 
{
	static VCResponseFetcher *sharedInstance = nil;
	
	if (sharedInstance == nil) 
	{
		sharedInstance = [[VCResponseFetcher alloc] init];
	}
	
	return sharedInstance;
}

- (void)addObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer
				url:(NSString*)url
			  cache:(NSURLRequestCachePolicy)cache
  responseProcessor:(NSObject<VCDataProcessorDelegate>*)processor
{	
	VCResponseFetchService *operation = [[[VCResponseFetchService alloc] init] autorelease];
	operation.delegate = observer;
	operation.url = url;
	operation.responseProcessor = processor;
	operation.cachePolicy = cache;
	
	if (cache != NSURLRequestReturnCacheDataElseLoad) {
		[_localOperationQueue addOperation:operation];
	}else {
		[_networkOperationQueue addOperation:operation];
	}
#if DEBUG	
	NSLog(@"operationCount : %i", [_networkOperationQueue operationCount]);
#endif
}

- (void)removeObserver:(NSObject<VCResponseFetchServiceDelegate>*)observer 
{
	for (VCResponseFetchService *operation in [_networkOperationQueue operations]) {
		if (operation.delegate == observer) {
			[operation cancel];
			operation.delegate = nil;
		}
	}
#if DEBUG
	NSLog(@"operationCount : %i", [_networkOperationQueue operationCount]);
#endif
}

@end
