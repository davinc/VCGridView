//
//  VCThumbnailGridView.h
//  
//
//  Created by Vinay Chavan on 19/03/11.
//  Copyright 2011 Vinay Chavan. All rights reserved.
//

/*
 * create UIThumbnailGridViewItem { image or imageUrl }
 * if items go out of the screen, remove subviews representing those items
 * add scroll delegate methods to check which cells are turning visible or going out of the screen
 * 
 */

#import <UIKit/UIKit.h>

enum VCThumbnailGridViewStyle {
	VCThumbnailGridViewStyleGrid = 0,
	VCThumbnailGridViewStyleStripe = 1
};
typedef NSUInteger VCThumbnailGridViewStyle;

@protocol VCThumbnailGridViewDataSource;
@protocol VCThumbnailGridViewDelegate;

@class URLImageView;

@interface VCThumbnailGridView : UIScrollView {
    id<VCThumbnailGridViewDelegate> _gridDelegate;
	id<VCThumbnailGridViewDataSource> _gridDataSource;
	VCThumbnailGridViewStyle _style;
	
	NSInteger _numberOfThumbnails;
	NSInteger _numberOfThumbnailsInRow;
	CGFloat _thumbnailHeight;
	CGFloat _thumbnailWidth;
	CGFloat _thumbnailBorderWidth;
	
	NSMutableArray *_thumbnails;
	UIView *_footerView;
}

@property (nonatomic, assign) id<VCThumbnailGridViewDelegate> gridDelegate;
@property (nonatomic, assign) id<VCThumbnailGridViewDataSource> gridDataSource;
@property (nonatomic, assign) VCThumbnailGridViewStyle style;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, retain) UIView *footerView;

- (void)reloadData;

@end


@protocol VCThumbnailGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfThumbnailsInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView;

@optional
- (NSInteger)numberOfThumbnailsInRowInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView;
- (UIImage*)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView imageAtIndex:(NSInteger)index;
- (NSString*)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView imageUrlAtIndex:(NSInteger)index;
- (NSString*)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView titleForThumbnailAtIndex:(NSInteger)index;

@end

@protocol VCThumbnailGridViewDelegate <NSObject>

@optional
- (void)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView didSelectThumbnailAtIndex:(NSInteger)index;

@end
