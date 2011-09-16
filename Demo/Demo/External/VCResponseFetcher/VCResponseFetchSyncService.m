//
//  VCResponseFetchSyncService.m
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/7/11.
//  
//  Copyright (C) 2011 by Vinay Chavan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions: 
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "VCResponseFetchSyncService.h"

@interface VCResponseFetchSyncService()
-(void)didFinish;
-(void)didFail:(NSError *)error;
-(void)notifyStart;
-(void)notifyFinish;
@end

@implementation VCResponseFetchSyncService

@synthesize delegate, url, responseProcessor, cachePolicy, allHTTPHeaderFields, body, method;

-(id)init
{
	self = [super init];
	if (self) {
		self.delegate = nil;
		self.url = nil;
		self.responseProcessor = nil;
		self.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
		self.allHTTPHeaderFields = nil;
	}
	return self;
}

-(void)dealloc
{
	[url release], url = nil;
	[responseProcessor release], responseProcessor = nil;
	[allHTTPHeaderFields release], allHTTPHeaderFields = nil;
	[body release], body = nil;
	[method release], method = nil;
	[super dealloc];
}

-(void)start
{
	if (self.url == nil) {
		[self notifyFinish];
		return;	
	}

	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	[self notifyStart];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
														   cachePolicy:self.cachePolicy
													   timeoutInterval:30];
	NSHTTPURLResponse *resposne = nil;
	NSData *data = nil;
	NSError *error = nil;

	if (self.method) {
		[request setHTTPMethod:self.method];
	}
	if (self.allHTTPHeaderFields) {
		[request setAllHTTPHeaderFields:self.allHTTPHeaderFields];
	}
	if (self.body) {
		[request setHTTPBody:self.body];
	}
	
	NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
	if (cachedResponse) {
		data = [cachedResponse data];
		resposne = (NSHTTPURLResponse *)[cachedResponse response];
	}

	if (data == nil) 
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		data = [NSURLConnection sendSynchronousRequest:request 
									 returningResponse:&resposne 
												 error:&error];
		if (error == nil && data != nil) {
			[[NSURLCache sharedURLCache] storeCachedResponse:[[[NSCachedURLResponse alloc]initWithResponse:resposne 
																									  data:data]autorelease]
												  forRequest:request];
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
