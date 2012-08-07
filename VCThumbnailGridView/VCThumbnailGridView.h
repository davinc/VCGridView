//
//  VCThumbnailGridView.h
//  
//
//  Created by Vinay Chavan on 19/03/11.
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

/*
 * create UIThumbnailGridViewItem { image or imageUrl }
 * if items go out of the screen, remove subviews representing those items
 * add scroll delegate methods to check which cells are turning visible or going out of the screen
 * 
 */

#import <UIKit/UIKit.h>

#import "VCThumbnailViewCell.h"

@protocol VCThumbnailGridViewDataSource;
@protocol VCThumbnailGridViewDelegate;

@interface VCThumbnailGridView : UIView <UITableViewDataSource, UITableViewDelegate> {
@private
    id<VCThumbnailGridViewDelegate> _delegate;
	id<VCThumbnailGridViewDataSource> _dataSource;
	
	UITableView *_tableView;
	NSMutableIndexSet *_selectedIndexes;
	NSInteger _numberOfThumbnails;
	NSInteger _numberOfThumbnailsInRow;
	CGFloat _thumbnailSpacing;
	BOOL _isEditing;
}

@property (nonatomic, assign) id<VCThumbnailGridViewDelegate> delegate;
@property (nonatomic, assign) id<VCThumbnailGridViewDataSource> dataSource;
@property (nonatomic, readonly) BOOL isEditing;
@property (nonatomic, readonly) NSIndexSet *selectedIndexes;

@property (nonatomic, retain) UIView *gridHeaderView;
@property (nonatomic, retain) UIView *gridFooterView;

- (void)reloadData;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (VCThumbnailButton *)thumbnailAtIndex:(NSInteger)index;

@end


@protocol VCThumbnailGridViewDataSource <NSObject>

@required
- (NSInteger)numberOfThumbnailsInThumbnailGridView:(VCThumbnailGridView*)thumbnailGridView;

@optional
- (NSInteger)numberOfThumbnailsInRowForThumbnailGridView:(VCThumbnailGridView *)thumbnailGridView;
- (VCThumbnailButton *)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView thumbnailViewAtIndex:(NSInteger)index reusableThumbnailView:(VCThumbnailButton *)reusableThumbnailView;
- (BOOL)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView canEditThumbnailAtIndex:(NSInteger)index;
@end

@protocol VCThumbnailGridViewDelegate <NSObject>

@optional
- (CGFloat)spacingOfThumbnailsInThumbnailGridView:(VCThumbnailGridView *)thumbnailGridView;
- (CGFloat)heightForRowsInThumbnailGridView:(VCThumbnailGridView *)thumbnailGridView;
- (void)thumbnailGridView:(VCThumbnailGridView *)thumbnailGridView didSelectThumbnailAtIndex:(NSInteger)index;

@end
