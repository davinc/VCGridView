//
//  VCImageView.m
//  
//
//  Created by Vinay Chavan on 12/12/10.
//  Copyright 2010 . All rights reserved.
//

#import "VCThumbnailButton.h"
#import "UIImageAdditions.h"

#import <QuartzCore/QuartzCore.h>

@implementation VCThumbnailButton

@synthesize roundedCorner;
@synthesize shouldShowActivityIndicator;
@synthesize shouldAutoRotateToFit;
@synthesize isSelected;

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
		
		selectedIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		selectedIndicatorImageView.image = [UIImage imageNamed:@"check.png"];
		[selectedIndicatorImageView sizeToFit];
		selectedIndicatorImageView.hidden = YES;
		[self addSubview:selectedIndicatorImageView];
		
		[self addTarget:self action:@selector(didTapSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc {
	[selectedIndicatorImageView release];
	[activityIndicator release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
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
	}else 
	{
		if (delegate) {
			if ([delegate respondsToSelector:callback]) {
				[delegate performSelector:callback withObject:self];
			}
		}
	}
}



#pragma mark - Public Methods

- (void)setImageUrl:(NSString*)url {
	[[VCResponseFetcher sharedInstance] addObserver:self
												url:url
									responseOfClass:[VCImageResponseProcessor class]];
	
	if (shouldShowActivityIndicator) {
		if (!activityIndicator) {
			activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
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
	NSLog(@"Index:%i selected:%i", self.tag, selected);
#endif
	
	selectedIndicatorImageView.hidden = !isSelected;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
	isEditing = editing;
	
	if (animated) [UIView beginAnimations:nil context:nil];
	
	if (isEditing)
	{
		self.alpha = 0.8;
	}else
	{
		self.alpha = 1.0;
	}
	
	if (animated) [UIView commitAnimations];
	
	[self setSelected:NO animated:YES];
}

#pragma mark - VCResponseFetchServiceDelegate Methods

-(void)didSucceedReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	if ([response isKindOfClass:[VCImageResponseProcessor class]]) {
		UIImage *image = [(VCImageResponseProcessor*)response image];
		[self setBackgroundImage:image
						forState:UIControlStateNormal];

	}
}

-(void)didFailReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	
}


@end
