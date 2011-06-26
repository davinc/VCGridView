//
//  VCImageView.h
//  
//
//  Created by Vinay Chavan on 12/12/10.
//  Copyright 2010 Bytefeast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCImageView : UIImageView {
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

