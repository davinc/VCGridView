//
//  UrlShortnerResponseProcessor.h
//  ZoomApp
//
//  Created by Vinay Chavan on 07/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VCDataProcessorDelegate.h"

@interface UrlShortnerResponseProcessor : NSObject <VCDataProcessorDelegate> {
    
}

@property (nonatomic, retain) NSString *longUrl;
@property (nonatomic, retain) NSString *shortUrl;
@property (nonatomic, retain) NSError *error;

@end
