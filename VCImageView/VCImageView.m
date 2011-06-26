//
//  VCImageView.m
//  
//
//  Created by Vinay Chavan on 12/12/10.
//  Copyright 2010 Bytefeast. All rights reserved.
//

#import "VCImageView.h"
#import "UIImageAdditions.h"

@implementation VCImageView

@synthesize roundedCorner;
@synthesize shouldShowActivityIndicator;
@synthesize shouldAutoRotateToFit;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		delegate = nil;
		callback = NULL;
		roundedCorner = NO;
		shouldShowActivityIndicator = NO;
		shouldAutoRotateToFit = NO;
		self.autoresizesSubviews = YES;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	activityIndicator.frame = CGRectMake((self.bounds.size.width - activityIndicator.bounds.size.width)/2, 
										 (self.bounds.size.height - activityIndicator.bounds.size.height)/2,
										 activityIndicator.bounds.size.width,
										 activityIndicator.bounds.size.height);
}



#pragma mark - Private Methods

- (void)didTapSelf:(id)sender {
	if (delegate) {
		if ([delegate respondsToSelector:callback]) {
			[delegate performSelector:callback withObject:self];
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
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSelf:)];
		[self addGestureRecognizer:tapGesture];
		[tapGesture release];

		delegate = target;
		callback = selector;
	}	
}


#pragma mark - VCResponseFetchServiceDelegate Methods

-(void)didSucceedReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	if ([response isKindOfClass:[VCImageResponseProcessor class]]) {
		UIImage *image = [(VCImageResponseProcessor*)response image];
		self.image = image;
	}
}

-(void)didFailReceiveResponse:(NSObject<VCDataProcessorDelegate> *)response {
	
}


@end
