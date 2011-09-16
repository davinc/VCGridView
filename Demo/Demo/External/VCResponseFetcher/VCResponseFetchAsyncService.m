//
//  VCResponseFetchAsyncService.m
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 04/09/11.
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

#import "VCResponseFetchAsyncService.h"


@interface VCResponseFetchAsyncService()
-(void)didFinish;
-(void)didFail:(NSError *)error;
-(void)notifyStart;
-(void)notifyFinish;
@end

@implementation VCResponseFetchAsyncService

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
	
	if (self.method) {
		[request setHTTPMethod:self.method];
	}
	if (self.allHTTPHeaderFields) {
		[request setAllHTTPHeaderFields:self.allHTTPHeaderFields];
	}
	if (self.body) {
		[request setHTTPBody:self.body];
	}

	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
																delegate:self];
	[connection start];
	
	do {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
	} while (executing);
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


#pragma mark - NSOperationDelegate Methods

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSCachedURLResponse *memOnlyCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response
																						  data:cachedResponse.data
																					  userInfo:cachedResponse.userInfo
																				 storagePolicy:NSURLCacheStorageAllowed];
    return [memOnlyCachedResponse autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if (self.isCancelled) {
		NSLog(@"Canceling in didReceiveResponse");
		[connection cancel];
		[self didFail:nil];
		[self notifyFinish];
		return;
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)receivedData
{
	if (self.isCancelled) {
		NSLog(@"Canceling in didReceiveData");
		[connection cancel];
		[self didFail:nil];
		[self notifyFinish];
		return;
	}
	
	if (data == nil) {
		data = [[NSMutableData alloc] init];
	}
	
	[data appendData:receivedData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (self.isCancelled) {
		NSLog(@"Canceling in connectionDidFinishLoading");
		[connection cancel];
		[self didFail:nil];
		[self notifyFinish];
		return;
	}

	[self.responseProcessor processData:data];
	[self didFinish];
	[self notifyFinish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (self.isCancelled) {
		NSLog(@"Canceling in didFailWithError");
		[connection cancel];
		[self didFail:nil];
		[self notifyFinish];
		return;
	}

	[self didFail:error];
	[self notifyFinish];
}

@end
