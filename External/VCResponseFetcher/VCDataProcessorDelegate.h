//
//  VCResponseDelegate.h
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/11/11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol VCDataProcessorDelegate <NSObject>

@required
-(void)processData:(NSData*)receivedData;

// getter, setter for error
-(NSError*)error;
-(void)setError:(NSError*)anError;

@end
