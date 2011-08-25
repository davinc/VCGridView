//
//  VCImageView.h
//
//  Created by Vinay Chavan on 12/12/10.
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

#import <UIKit/UIKit.h>

#import "VCResponseFetcher.h"

@interface VCThumbnailButton : UIView <VCResponseFetchServiceDelegate> {
	UIButton *imageButton;
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
@property (readonly) BOOL isSelected;
@property (readonly) BOOL isEditing;

- (void)setImage:(UIImage*)image;
- (void)setImageUrl:(NSString*)url;

- (void)addTarget:(id)target withSelector:(SEL)selector;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

