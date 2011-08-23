//
//  CGResponseFetchService.m
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/7/11.
//  Copyright 2011 . All rights reserved.
//

#import "VCResponseFetchService.h"

@interface VCResponseFetchService()
-(void)didFinish;
-(void)didFail:(NSError *)error;
-(void)notifyStart;
-(void)notifyFinish;
@end

@implementation VCResponseFetchService

@synthesize delegate, url, responseProcessor, cachePolicy;

-(id)init
{
	self = [super init];
	if (self) {
		self.delegate = nil;
		self.url = nil;
		self.responseProcessor = nil;
		self.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
	}
	return self;
}

-(void)dealloc
{
	[url release], url = nil;
	[responseProcessor release], responseProcessor = nil;
	[super dealloc];
}

-(void)start
{
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	
	if (self.url == nil) {
		[self notifyFinish];
		[autoreleasePool release], autoreleasePool = nil;
		return;	
	}
	
	// Starting
	if( [self isCancelled] ) {
		[self notifyFinish];
		[autoreleasePool release], autoreleasePool = nil;
		return;	
	}
	
	[self notifyStart];
	
	// Processing
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
														   cachePolicy:self.cachePolicy
													   timeoutInterval:30];
	NSHTTPURLResponse *resposne = nil;
	NSData *data = nil;
	NSError *error = nil;
	
	NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
	if (cachedResponse) {
		data = [cachedResponse data];
		resposne = [cachedResponse response];
	}

	if (data == nil) 
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		data = [NSURLConnection sendSynchronousRequest:request returningResponse:&resposne error:&error];
		if (error == nil && data != nil) {
			NSLog(@"%@", [resposne allHeaderFields]);
			NSLog(@"currentMemoryUsage : %i", [[NSURLCache sharedURLCache] currentMemoryUsage]);
			[[NSURLCache sharedURLCache] storeCachedResponse:[[[NSCachedURLResponse alloc]initWithResponse:resposne 
																									  data:data]autorelease]
												  forRequest:request];
			NSLog(@"currentMemoryUsage : %i", [[NSURLCache sharedURLCache] currentMemoryUsage]);
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}

	// Ending
	if( [self isCancelled] ) {
		[self notifyFinish];
		[autoreleasePool release], autoreleasePool = nil;
		return;	
	}
	
	if (error) 
	{
		[self didFail:error];
	}
	else 
	{
		[self.responseProcessor processData:data];
		[self didFinish];
	}
	
	[self notifyFinish];
	[autoreleasePool release], autoreleasePool = nil;
}

#pragma mark - Private Methods

-(void)didFinish
{
	if ([self.delegate respondsToSelector:@selector(didSucceedReceiveResponse:)]) 
	{
		[self.delegate performSelectorOnMainThread:@selector(didSucceedReceiveResponse:)
										withObject:self.responseProcessor
									 waitUntilDone:NO];
	}
}

-(void)didFail:(NSError *)error
{
	[self.responseProcessor setError:error];
	if ([self.delegate respondsToSelector:@selector(didFailReceiveResponse:)])
	{
		[self.delegate performSelectorOnMainThread:@selector(didFailReceiveResponse:)
										withObject:self.responseProcessor
									 waitUntilDone:NO];
	}
}

-(void)notifyStart 
{
	[self willChangeValueForKey:@"isExecuting"];
	executing = YES;
	finished = NO;
	[self didChangeValueForKey:@"isExecuting"];
}

-(void)notifyFinish 
{
	[self willChangeValueForKey:@"isExecuting"];
	[self willChangeValueForKey:@"isFinished"];
	executing = NO;
	finished  = YES;
	[self didChangeValueForKey:@"isFinished"];
	[self didChangeValueForKey:@"isExecuting"];
}

-(BOOL)isConcurrent
{
	return NO;
}

-(BOOL)isExecuting
{
	return executing;
}

-(BOOL)isFinished
{
	return finished;
}

@end
