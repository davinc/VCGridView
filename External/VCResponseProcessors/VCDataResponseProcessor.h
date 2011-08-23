//
//  VCDataResponseProcessor.h
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/7/11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VCDataProcessorDelegate.h"

@interface VCDataResponseProcessor : NSObject <VCDataProcessorDelegate> {
}
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSError *error;

@end
