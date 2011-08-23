//
//  VCImageResponseProcessor.m
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCImageResponseProcessor.h"


@implementation VCImageResponseProcessor

@synthesize image, error;

-(id)init
{
	self = [super init];
	if (self) {
		image = nil;
		error = nil;
	}
	return self;
}

-(void)dealloc
{
	[image release], image = nil;
	[error release], error = nil;
	[super dealloc];
}

#pragma mark - Public Method
// For custom implementation override this method
-(void)processData:(NSData*)receivedData
{
	self.image = [UIImage imageWithData:receivedData];
}

@end
