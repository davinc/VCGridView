//
//  VCResponseFetchServiceDelegate.h
//  VCResponseFetcherTest
//
//  Created by Vinay Chavan on 4/11/11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VCDataProcessorDelegate.h"

@protocol VCResponseFetchServiceDelegate <NSObject>

@optional
-(void)didSucceedReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response;
-(void)didFailReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response;

@end
