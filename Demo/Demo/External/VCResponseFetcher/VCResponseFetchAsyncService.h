//
//  VCResponseFetchAsyncService.h
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

#import <Foundation/Foundation.h>
#import "VCResponseFetchServiceDelegate.h"
#import "VCDataProcessorDelegate.h"

@interface VCResponseFetchAsyncService : NSOperation {
	NSObject<VCResponseFetchServiceDelegate> *delegate;
	NSObject<VCDataProcessorDelegate> *responseProcessor;
	NSString *url;
	NSURLRequestCachePolicy cachePolicy;
	NSString *method;
	NSDictionary *allHTTPHeaderFields;
	NSData *body;
	NSMutableData *data; // received Data
	
	BOOL executing;
	BOOL finished;
}

@property (nonatomic, assign) NSObject<VCResponseFetchServiceDelegate> *delegate;
@property (nonatomic, retain) NSObject<VCDataProcessorDelegate> *responseProcessor;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, retain) NSDictionary *allHTTPHeaderFields;
@property (nonatomic, retain) NSData *body;
@property (nonatomic, retain) NSString *method;

@end
