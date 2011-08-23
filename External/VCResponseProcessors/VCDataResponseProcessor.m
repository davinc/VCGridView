//
//  VCDataResponseProcessor.m
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/7/11.
//  Copyright 2011 . All rights reserved.
//

#import "VCDataResponseProcessor.h"


@implementation VCDataResponseProcessor

@synthesize data, error;

-(id)init
{
	self = [super init];
	if (self) {
		data = nil;
		error = nil;
	}
	return self;
}

-(void)dealloc
{
	[data release], data = nil;
	[error release], error = nil;
	[super dealloc];
}

#pragma mark - Public Method
// For custom implementation override this method
-(void)processData:(NSData*)receivedData
{
	self.data = [[[NSData alloc] initWithData:receivedData] autorelease];
}

@end
