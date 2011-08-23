//
//  UrlShortnerResponseProcessor.m
//  ZoomApp
//
//  Created by Vinay Chavan on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UrlShortnerResponseProcessor.h"

#import "NSString+SBJSON.h"

@implementation UrlShortnerResponseProcessor

@synthesize longUrl, shortUrl, error;

-(id)init
{
	self = [super init];
	if (self) {
		longUrl = nil;
		shortUrl = nil;
		error = nil;
	}
	return self;
}

-(void)dealloc
{
	[longUrl release], longUrl = nil;
	[shortUrl release], shortUrl = nil;
	[error release], error = nil;
	[super dealloc];
}

#pragma mark - Public Method
// For custom implementation override this method
-(void)processData:(NSData*)receivedData
{
	NSString *receivedString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	id value = [receivedString JSONValue];
	if ([value isKindOfClass:[NSDictionary class]]) {
		NSNumber* errorCode = [value valueForKey:@"errorCode"];
		if ([errorCode intValue] == 0) {
			// continue
			self.shortUrl = [[[value valueForKey:@"results"] valueForKey:self.longUrl] valueForKey:@"shortUrl"];
		}else {
			self.error = [[[NSError alloc] initWithDomain:nil code:[errorCode intValue] userInfo:nil] autorelease];
		}
	}
	[receivedString release];
}

@end
