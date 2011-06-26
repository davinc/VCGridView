//
//  VCImageView.h
//  
//
//  Created by Vinay Chavan on 12/12/10.
//  Copyright 2010 Bytefeast. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VCResponseFetcher.h"

@interface VCImageView : UIImageView <VCResponseFetchServiceDelegate> {
	UIActivityIndicatorView *activityIndicator;
	BOOL shouldShowActivityIndicator;
	BOOL shouldAutoRotateToFit;
	
	// Rounded Corner
	BOOL roundedCorner;
	
	// Tap
	id delegate;
	SEL callback;
}

@property (assign) BOOL roundedCorner;
@property (assign) BOOL shouldShowActivityIndicator;
@property (assign) BOOL shouldAutoRotateToFit;

- (void)setImageUrl:(NSString*)url;

- (void)addTarget:(id)target withSelector:(SEL)selector;

@end

