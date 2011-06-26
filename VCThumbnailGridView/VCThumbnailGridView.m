//
//  VCThumbnailGridView.m
//  
//
//  Created by Vinay Chavan on 19/03/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

#import "VCThumbnailGridView.h"

#import <QuartzCore/QuartzCore.h>

#import "VCImageView.h"

@interface VCThumbnailGridView()

- (void)createGrid;
- (void)createStripe;

@end

@implementation VCThumbnailGridView

@synthesize gridDelegate = _gridDelegate, gridDataSource = _gridDataSource, style = _style, rowHeight = _thumbnailHeight, footerView = _footerView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_gridDelegate = nil;
		_gridDataSource = nil;
		_footerView = nil;
		
		_numberOfThumbnailsInRow = 4;
		_style = VCThumbnailGridViewStyleGrid;
		
		_thumbnails = nil;
    }
    return self;
}

- (void)layoutSubviews {
	if (_thumbnails == nil) {
		// need to read data from the delegates
		if (_style == VCThumbnailGridViewStyleGrid) {
			[self createGrid];
		}else if (_style == VCThumbnailGridViewStyleStripe) {
			[self createStripe];
		}
	}
}


- (void)dealloc {
	[_thumbnails release], _thumbnails = nil;
	[_footerView release], _footerView = nil;
    [super dealloc];
}



#pragma mark - Public Methods

- (void)reloadData {
	[_thumbnails removeAllObjects];
	[_thumbnails release], _thumbnails = nil;
	
	// remove all subviews
	for (UIView *subView in self.subviews) {
		[subView performSelector:@selector(removeFromSuperview)];
	}
	
	[self setNeedsLayout];
}

- (void)setFooterView:(UIView *)footerView {
	[_footerView removeFromSuperview];
	
	[_footerView release], _footerView = nil;
	_footerView = [footerView retain];
	
	// add subview
	[self setNeedsLayout];
}


#pragma mark - Private Methods

- (void)createGrid {
	// read number of images
	if ([self.gridDataSource respondsToSelector:@selector(numberOfThumbnailsInThumbnailGridView:)]) {
		_numberOfThumbnails = [self.gridDataSource numberOfThumbnailsInThumbnailGridView:self];
		
		_numberOfThumbnails = _numberOfThumbnails < 0 ? 0 : _numberOfThumbnails;
	}
	
	if ([self.gridDataSource respondsToSelector:@selector(numberOfThumbnailsInRowInThumbnailGridView:)]) {
		_numberOfThumbnailsInRow = [self.gridDataSource numberOfThumbnailsInRowInThumbnailGridView:self];
		
		_numberOfThumbnailsInRow = _numberOfThumbnailsInRow <= 0 ? 4 : _numberOfThumbnailsInRow;
	}
	
	// calculate sizes for image and border
	_thumbnailBorderWidth = 0;
	
	_thumbnailWidth = self.bounds.size.width / (CGFloat)_numberOfThumbnailsInRow;
	_thumbnailHeight = _thumbnailWidth + 10;
		
	// resize the scrollable area
	NSInteger _numberOfRows = roundf((CGFloat)_numberOfThumbnails / (CGFloat)_numberOfThumbnailsInRow);
	self.contentSize = CGSizeMake(self.bounds.size.width,
								  _thumbnailHeight * _numberOfRows + _footerView.bounds.size.height);
	if (_footerView) {
		CGRect footerFrame = _footerView.bounds;
		footerFrame.origin.y = self.contentSize.height - _footerView.bounds.size.height;
		footerFrame.size.width = self.contentSize.width;
		_footerView.frame = footerFrame;
		[self addSubview:_footerView];
	}

	// create array to hold it
	if (_thumbnails) {
		[_thumbnails removeAllObjects];
		[_thumbnails release], _thumbnails = nil;
	}
	_thumbnails = [[NSMutableArray alloc] initWithCapacity:_numberOfThumbnails];
	
	// Get urls or images from the datasource
	CGFloat currentOffsetX = 0, currentOffsetY = 0;
	for (int counter = 0; counter < _numberOfThumbnails; counter++) {
		NSString *imageUrl = nil;
		UIImage *image = nil;
		NSString *imageTitle = nil;
		
		if ([self.gridDataSource respondsToSelector:@selector(thumbnailGridView:imageAtIndex:)]) {
			image = [self.gridDataSource thumbnailGridView:self imageAtIndex:counter];
		}
		if ([self.gridDataSource respondsToSelector:@selector(thumbnailGridView:imageUrlAtIndex:)]) {
			imageUrl = [self.gridDataSource thumbnailGridView:self imageUrlAtIndex:counter];
		}
		if ([self.gridDataSource respondsToSelector:@selector(thumbnailGridView:titleForThumbnailAtIndex:)]) {
			imageTitle = [self.gridDataSource thumbnailGridView:self titleForThumbnailAtIndex:counter];
		}

		// ImageView
		VCImageView *imageView = [[VCImageView alloc] initWithFrame:CGRectZero];
		[imageView.layer setBorderColor:[[UIColor colorWithWhite:0.7 alpha:1.0] CGColor]];
		[imageView.layer setBorderWidth:1.0];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.opaque = YES;
		imageView.clipsToBounds = YES;
		imageView.backgroundColor = self.backgroundColor;
		imageView.shouldShowActivityIndicator = YES;
		
		//Title label
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		titleLabel.backgroundColor = self.backgroundColor;
		titleLabel.textColor = [UIColor colorWithRed:0.102 green:0.608 blue:0.906 alpha:1.0];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		titleLabel.numberOfLines = 2;
		titleLabel.text = imageTitle;
		
		// placement
		CGRect itemFrame = CGRectMake(currentOffsetX, currentOffsetY, _thumbnailWidth, _thumbnailHeight);
		if (imageTitle) {
			imageView.frame = CGRectMake(currentOffsetX + 10, 
										 currentOffsetY + 2, 
										 _thumbnailWidth - 20, 
										 _thumbnailHeight - 24);
			titleLabel.frame = CGRectMake(currentOffsetX + 2, 
										  currentOffsetY + _thumbnailHeight - 20, 
										  _thumbnailWidth - 4, 
										  20);
		}else {
			imageView.frame = CGRectInset(itemFrame, 2, 2);
			titleLabel.frame = CGRectZero;
		}		
		
		currentOffsetX += _thumbnailWidth;
		if (currentOffsetX >= self.bounds.size.width) {
			currentOffsetY += _thumbnailHeight;
			currentOffsetX = 0;
		}

		[imageView addTarget:self withSelector:@selector(didTapImageThumbnail:)];

		// add to the view
		[_thumbnails addObject:imageView];
		[self addSubview:imageView];
		[self addSubview:titleLabel];
		
		if (image) {
			imageView.image = image;
		}
		if (imageUrl) {
			[imageView setRemoteImageUrl:imageUrl];
		}

		[imageView release], imageView = nil;
		[titleLabel release], titleLabel = nil;
	}
}

- (void)createStripe {
	// read number of images
	if ([self.gridDataSource respondsToSelector:@selector(numberOfThumbnailsInThumbnailGridView:)]) {
		_numberOfThumbnails = [self.gridDataSource numberOfThumbnailsInThumbnailGridView:self];
		
		_numberOfThumbnails = _numberOfThumbnails < 0 ? 0 : _numberOfThumbnails;
	}
	
	// calculate sizes for image and border
	_thumbnailBorderWidth = 0;
	
	_thumbnailWidth = self.bounds.size.width / (CGFloat)_numberOfThumbnailsInRow;
	_thumbnailHeight = _thumbnailWidth;
	
	// resize the scrollable area
	self.contentSize = CGSizeMake(_numberOfThumbnails * _thumbnailWidth,
								  self.bounds.size.height);
	
	// create array to hold it
	if (_thumbnails) {
		[_thumbnails removeAllObjects];
		[_thumbnails release], _thumbnails = nil;
	}
	_thumbnails = [[NSMutableArray alloc] initWithCapacity:_numberOfThumbnails];
	
	// Get urls or images from the datasource
	CGFloat currentOffsetX = 0, currentOffsetY = 0;
	for (int counter = 0; counter < _numberOfThumbnails; counter++) {
		VCImageView *imageView = [[VCImageView alloc] initWithFrame:CGRectMake(currentOffsetX + 2,
																				 currentOffsetY + 2,
																				 _thumbnailWidth - 4,
																				 _thumbnailHeight - 4)];
		[imageView.layer setBorderColor:[[UIColor colorWithWhite:0.7 alpha:1.0] CGColor]];
		[imageView.layer setBorderWidth:1.0];
		imageView.backgroundColor = self.backgroundColor;
		imageView.shouldShowActivityIndicator = YES;
		currentOffsetX += _thumbnailWidth;
		
		[imageView addTarget:self withSelector:@selector(didTapImageThumbnail:)];
		
		if ([self.gridDataSource respondsToSelector:@selector(thumbnailGridView:imageAtIndex:)]) {
			imageView.image = [self.gridDataSource thumbnailGridView:self imageAtIndex:counter];
		}
		if ([self.gridDataSource respondsToSelector:@selector(thumbnailGridView:imageUrlAtIndex:)]) {
			[imageView setRemoteImageUrl:[self.gridDataSource thumbnailGridView:self imageUrlAtIndex:counter]];
		}
		// add to the view
		[_thumbnails addObject:imageView];
		[self addSubview:imageView];
		
		[imageView release], imageView = nil;
	}
}


#pragma mark - Private Methods

- (void)didTapImageThumbnail:(VCImageView*)imageView {
	NSInteger index = [_thumbnails indexOfObject:imageView];
	
	if ([self.gridDelegate respondsToSelector:@selector(thumbnailGridView:didSelectThumbnailAtIndex:)]) {
		[self.gridDelegate thumbnailGridView:self didSelectThumbnailAtIndex:index];
	}
}

@end
