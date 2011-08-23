//
//  VCImageResponseProcessor.h
//  Demo
//
//  Created by Vinay Chavan on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VCDataProcessorDelegate.h"

@interface VCImageResponseProcessor : NSObject<VCDataProcessorDelegate> {
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSError *error;

@end
