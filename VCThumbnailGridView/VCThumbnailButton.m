//
//  VCImageView.m
//  
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

#import "VCThumbnailButton.h"

#import "VCImageResponseProcessor.h"

@implementation VCThumbnailButton

@synthesize roundedCorner;
@synthesize shouldShowActivityIndicator;
@synthesize shouldAutoRotateToFit;
@synthesize isSelected;
@synthesize isEditing;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		shouldShowActivityIndicator = NO;
		shouldAutoRotateToFit = NO;
		self.autoresizesSubviews = YES;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeScaleAspectFit;
		
		imageButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[imageButton addTarget:self action:@selector(didTapSelf:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:imageButton];
		
		selectedIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		selectedIndicatorImageView.alpha = 0.0;
		selectedIndicatorImageView.image = [UIImage imageNamed:@"check.png"];
		[selectedIndicatorImageView sizeToFit];
		[self addSubview:selectedIndicatorImageView];
    }
    return self;
}

- (void)dealloc {
	[imageButton release];
	[selectedIndicatorImageView release];
	[activityIndicator release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	imageButton.frame = self.bounds;
	activityIndicator.frame = CGRectMake((self.bounds.size.width - activityIndicator.bounds.size.width)/2, 
										 (self.bounds.size.height - activityIndicator.bounds.size.height)/2,
										 activityIndicator.bounds.size.width,
										 activityIndicator.bounds.size.height);
	selectedIndicatorImageView.frame = CGRectMake(self.bounds.size.width - selectedIndicatorImageView.bounds.size.width,
												  self.bounds.size.height - selectedIndicatorImageView.bounds.size.height,
												  selectedIndicatorImageView.bounds.size.width,
												  selectedIndicatorImageView.bounds.size.height);
}



#pragma mark - Private Methods

- (void)didTapSelf:(id)sender {
	if (isEditing) {
		[self setSelected:!isSelected animated:YES];
	}
	if (delegate && [delegate respondsToSelector:callback]) {
		[delegate performSelector:callback withObject:self];
	}
}



#pragma mark - Public Methods

- (void)setImage:(UIImage*)image {
	[imageButton setBackgroundImage:image
						   forState:UIControlStateNormal];
}

- (void)setImageUrl:(NSString*)url {
	[[VCResponseFetcher sharedInstance] addObserver:self
												url:url
											  cache:NSURLRequestReturnCacheDataElseLoad
								  responseProcessor:[[[VCImageResponseProcessor alloc] init] autorelease]];
	
	if (shouldShowActivityIndicator) {
		if (!activityIndicator) {
			activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			activityIndicator.hidesWhenStopped = YES;
			activityIndicator.userInteractionEnabled = NO;
		}
		[activityIndicator sizeToFit];
		[self addSubview:activityIndicator];
		[self bringSubviewToFront:activityIndicator];
		[activityIndicator startAnimating];
	}
}

- (void)addTarget:(id)target withSelector:(SEL)selector {
	self.userInteractionEnabled = YES;
	if ([self isUserInteractionEnabled]) {
		delegate = target;
		callback = selector;
	}	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	isSelected = selected;
#if DEBUG
//	NSLog(@"Index:%i selected:%i", self.tag, selected);
#endif
	
	if (animated) [UIView beginAnimations:nil context:nil];
	
	if (isSelected) 
	{
		selectedIndicatorImageView.alpha = 1.0;
		imageButton.alpha = 0.8;
	}
	else 
	{
		selectedIndicatorImageView.alpha = 0.0;
		imageButton.alpha = 1.0;
	}
	if (animated) [UIView commitAnimations];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
	if (isEditing != editing) {
		isEditing = editing;
		[self setSelected:NO animated:YES];
	}
}

#pragma mark - VCResponseFetchServiceDelegate Methods

-(void)didSucceedReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	[activityIndicator stopAnimating];
	
	if ([response isKindOfClass:[VCImageResponseProcessor class]]) {
		UIImage *image = [(VCImageResponseProcessor*)response image];
		[imageButton setBackgroundImage:image
							   forState:UIControlStateNormal];

	}
}

-(void)didFailReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	[activityIndicator stopAnimating];
}


@end
