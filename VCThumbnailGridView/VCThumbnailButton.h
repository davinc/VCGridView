//
//  VCImageView.h
//  
//
//  Created by Vinay Chavan on 12/12/10.
//  Copyright 2010 . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VCResponseFetcher.h"

@interface VCThumbnailButton : UIButton <VCResponseFetchServiceDelegate> {
	UIActivityIndicatorView *activityIndicator;
	UIImageView *selectedIndicatorImageView;
	BOOL shouldShowActivityIndicator;
	
	// Tap
	id delegate;
	SEL callback;
	
	// editing
	BOOL isSelected;
	BOOL isEditing;
}

@property (assign) BOOL roundedCorner;
@property (assign) BOOL shouldShowActivityIndicator;
@property (assign) BOOL shouldAutoRotateToFit;
@property (assign) BOOL isSelected;

- (void)setImageUrl:(NSString*)url;

- (void)addTarget:(id)target withSelector:(SEL)selector;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

