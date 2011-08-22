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

@protocol VCThumbnailGridViewDataSource;
@protocol VCThumbnailGridViewDelegate;

@class VCThumbnailButton;
@class VCThumbnailViewCell;

@interface VCThumbnailGridView : UIView <UITableViewDataSource, UITableViewDelegate> {
@private
    id<VCThumbnailGridViewDelegate> _delegate;
	id<VCThumbnailGridViewDataSource> _dataSource;
	
	UITableView *_tableView;
	NSInteger _numberOfThumbnails;
	BOOL _isEditing;
}

@property (nonatomic, assign) id<VCThumbnailGridViewDelegate> delegate;
@property (nonatomic, assign) id<VCThumbnailGridViewDataSource> dataSource;
@property (nonatomic, setter = setEditing) BOOL isEditing;

- (void)reloadData;
@end


@protocol VCThumbnailGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfThumbnailsInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView;

@optional
- (UIImage*)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView imageAtIndex:(NSInteger)index;
- (NSString*)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView imageUrlAtIndex:(NSInteger)index;

@end

@protocol VCThumbnailGridViewDelegate <NSObject>

@optional
- (void)thumbnailGridView:(VCThumbnailGridView*)thumbnailGridView didSelectThumbnailAtIndex:(NSInteger)index;

@end
